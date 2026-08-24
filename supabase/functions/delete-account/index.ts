// NDCard — delete-account Edge Function
// Çağıran kullanıcının kendi hesabını (auth.users satırı) ve buna bağlı
// tüm verilerini (tüm tablolar `on delete cascade` ile auth.users'a bağlı)
// siler. Ayrıca storage'daki {user_id}/... klasörlerini temizler.
// SUPABASE_SERVICE_ROLE_KEY, edge function ortamına Supabase tarafından
// otomatik sağlanır; istemci tarafında asla bulunmaz.

import { createClient } from "jsr:@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return json({ error: "Yetkilendirme başlığı eksik." }, 401);
  }

  try {
    // Çağıranın kimliğini, kendi JWT'siyle doğrulanan bir client üzerinden öğren.
    const callerClient = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
      global: { headers: { Authorization: authHeader } },
    });
    const {
      data: { user },
      error: userError,
    } = await callerClient.auth.getUser();

    if (userError || !user) {
      return json({ error: "Kullanıcı doğrulanamadı." }, 401);
    }

    const adminClient = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

    for (const bucket of ["card-images", "avatars"]) {
      const { data: files } = await adminClient.storage.from(bucket).list(user.id);
      if (files && files.length > 0) {
        const paths = files.map((f) => `${user.id}/${f.name}`);
        await adminClient.storage.from(bucket).remove(paths);
      }
    }

    const { error: deleteError } = await adminClient.auth.admin.deleteUser(user.id);
    if (deleteError) {
      return json({ error: "Hesap silinemedi." }, 500);
    }

    return json({ success: true }, 200);
  } catch (error) {
    console.error("delete-account error:", error);
    return json({ error: "Beklenmeyen bir hata oluştu." }, 500);
  }
});

function json(data: unknown, status: number): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, "content-type": "application/json" },
  });
}
