-- ===================================================
-- Telegram Clone Supabase Database Schema
-- Run this script in your Supabase SQL Editor:
-- https://supabase.com/dashboard/project/srvdrznwsryzblimfanx/sql
-- ===================================================

-- 1. Create Profiles Table
CREATE TABLE IF NOT EXISTS public.profiles (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  username TEXT,
  avatar_url TEXT,
  bio TEXT,
  phone_number TEXT,
  is_online BOOLEAN DEFAULT false,
  last_seen TEXT DEFAULT 'Recently',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create Chats Table
CREATE TABLE IF NOT EXISTS public.chats (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'private', -- private, group, channel, secret
  avatar_url TEXT,
  subtitle TEXT,
  folder_category TEXT DEFAULT 'Personal',
  unread_count INT DEFAULT 0,
  is_pinned BOOLEAN DEFAULT false,
  is_muted BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create Messages Table
CREATE TABLE IF NOT EXISTS public.messages (
  id TEXT PRIMARY KEY,
  chat_id TEXT NOT NULL REFERENCES public.chats(id) ON DELETE CASCADE,
  sender_id TEXT NOT NULL,
  sender_name TEXT NOT NULL,
  text TEXT,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  is_sent_by_me BOOLEAN DEFAULT true,
  is_read BOOLEAN DEFAULT false,
  message_type TEXT DEFAULT 'text', -- text, voice, image, file, poll
  voice_duration TEXT,
  media_url TEXT,
  file_name TEXT,
  file_size TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Enable Row Level Security (RLS) & Public Policies for Demo
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read/write on profiles" ON public.profiles FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public read/write on chats" ON public.chats FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public read/write on messages" ON public.messages FOR ALL USING (true) WITH CHECK (true);

-- 5. Enable Realtime Publications for Messages & Chats
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.chats;
