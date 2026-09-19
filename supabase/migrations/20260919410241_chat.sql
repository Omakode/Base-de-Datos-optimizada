-- 1. Habilitar la publicación de Realtime para la tabla de mensajes
ALTER PUBLICATION supabase_realtime ADD TABLE public.mensajes;

-- 2. (Opcional) Si quieres que la lista de conversaciones también se actualice en tiempo real
ALTER PUBLICATION supabase_realtime ADD TABLE public.conversaciones;