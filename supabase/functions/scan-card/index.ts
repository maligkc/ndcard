// NDCard — scan-card Edge Function
// Girdi: { image_base64: string, language?: string }
// Çıktı: { full_name, company, department, job_title, fields: [...] } (spec §5)
// ANTHROPIC_API_KEY yalnızca burada, edge function ortamında kullanılır.

import { corsHeaders } from "../_shared/cors.ts";

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY");
const MODEL = "claude-sonnet-4-6";
const RATE_LIMIT_PER_MINUTE = 10;

// Basit, isolate-içi bellek tabanlı rate limit (spec: "basit kontrol yeterli").
const rateLimitMap = new Map<string, number[]>();

function isRateLimited(key: string): boolean {
  const now = Date.now();
  const windowStart = now - 60_000;
  const timestamps = (rateLimitMap.get(key) ?? []).filter((t) => t > windowStart);
  if (timestamps.length >= RATE_LIMIT_PER_MINUTE) {
    rateLimitMap.set(key, timestamps);
    return true;
  }
  timestamps.push(now);
  rateLimitMap.set(key, timestamps);
  return false;
}

const SYSTEM_PROMPT = `Sen bir kartvizit (business card) tarama asistanısın. Sana bir kartvizit görüntüsü verilecek.
Görevin: Görseldeki bilgileri çıkarıp SADECE aşağıdaki JSON şemasına birebir uyan, başka hiçbir metin, açıklama, markdown kod bloğu içermeyen bir JSON döndürmek.

Şema:
{
  "full_name": string veya null,
  "company": string veya null,
  "department": string veya null,
  "job_title": string veya null,
  "fields": [
    {
      "field_type": "mobile" | "email" | "url" | "address" | "phone" | "fax",
      "label": string,
      "value": string,
      "address_detail": { "street": string, "city": string, "district": string, "postal_code": string, "country": string } veya null
    }
  ]
}

Kurallar:
- Yalnızca geçerli JSON döndür. Giriş/kapanış cümlesi, açıklama veya \`\`\` işareti EKLEME.
- Görselde olmayan bilgi için null kullan, uydurma.
- Telefon numaralarını "mobile" (cep) veya "phone" (sabit hat) olarak ayırt et; emin değilsen "phone" kullan.
- Faks numaraları "fax" tipinde olsun.
- Adres varsa "address" tipinde bir alan ekle; mümkünse address_detail'i doldur, değilse null bırak ama value'ya adresin tamamını yaz.
- Web siteleri ve diğer bağlantılar "url" tipinde olsun.
- label alanına kısa bir açıklama yaz (örn. "İş", "Cep"); bilmiyorsan boş string kullan.`;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (!ANTHROPIC_API_KEY) {
    return jsonResponse({ error: "ANTHROPIC_API_KEY yapılandırılmamış." }, 500);
  }

  const authHeader = req.headers.get("Authorization") ?? "anonymous";
  if (isRateLimited(authHeader)) {
    return jsonResponse(
      { error: "Çok fazla tarama isteği. Lütfen bir dakika sonra tekrar deneyin." },
      429,
    );
  }

  let body: { image_base64?: string; language?: string };
  try {
    body = await req.json();
  } catch {
    return jsonResponse({ error: "Geçersiz istek gövdesi." }, 422);
  }

  const imageBase64 = body.image_base64;
  const language = body.language ?? "tr";

  if (!imageBase64 || imageBase64.length < 100) {
    return jsonResponse({ error: "Geçerli bir görüntü gönderilmedi." }, 422);
  }

  try {
    const anthropicResponse = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "content-type": "application/json",
        "x-api-key": ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: MODEL,
        max_tokens: 1024,
        system: SYSTEM_PROMPT,
        messages: [
          {
            role: "user",
            content: [
              {
                type: "image",
                source: { type: "base64", media_type: "image/jpeg", data: imageBase64 },
              },
              {
                type: "text",
                text: `Yanıt dili: ${language}. Yukarıdaki kartvizit görüntüsünü şemaya göre JSON'a çevir.`,
              },
            ],
          },
        ],
      }),
    });

    if (!anthropicResponse.ok) {
      console.error("Anthropic API error:", await anthropicResponse.text());
      return jsonResponse({ error: "Kartvizit taranamadı." }, 502);
    }

    const anthropicJson = await anthropicResponse.json();
    const rawText = anthropicJson?.content?.[0]?.text as string | undefined;
    if (!rawText) {
      return jsonResponse({ error: "Model yanıtı ayrıştırılamadı." }, 422);
    }

    const parsed = extractJson(rawText);
    if (!parsed || !isValidSchema(parsed)) {
      return jsonResponse({ error: "Model yanıtı beklenen şemaya uymuyor." }, 422);
    }

    return jsonResponse(parsed, 200);
  } catch (error) {
    console.error("scan-card error:", error);
    return jsonResponse({ error: "Beklenmeyen bir hata oluştu." }, 500);
  }
});

function jsonResponse(data: unknown, status: number): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, "content-type": "application/json" },
  });
}

function extractJson(text: string): Record<string, unknown> | null {
  const start = text.indexOf("{");
  const end = text.lastIndexOf("}");
  if (start === -1 || end === -1 || end < start) return null;
  try {
    return JSON.parse(text.slice(start, end + 1));
  } catch {
    return null;
  }
}

function isValidSchema(data: Record<string, unknown>): boolean {
  if (!("fields" in data) || !Array.isArray(data.fields)) return false;
  for (const field of data.fields as unknown[]) {
    if (typeof field !== "object" || field === null) return false;
    const f = field as Record<string, unknown>;
    if (typeof f.field_type !== "string" || typeof f.value !== "string") return false;
  }
  return true;
}
