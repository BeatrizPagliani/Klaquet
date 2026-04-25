CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT no_self_follow CHECK (follower_id != following_id),
  UNIQUE (follower_id, following_id)
);

CREATE TABLE media_cache (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tmdb_id VARCHAR(20) UNIQUE NOT NULL,
  type VARCHAR(10) NOT NULL CHECK (type IN ('movie', 'series', 'anime')),
  title VARCHAR(255) NOT NULL,
  poster_url TEXT,
  release_year INT
);

CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  media_id UUID NOT NULL REFERENCES media_cache(id) ON DELETE CASCADE,
  rating DECIMAL(3,1) CHECK (rating >= 0 AND rating <= 10),
  body TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE (user_id, media_id)
);

CREATE TABLE review_details (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  review_id UUID UNIQUE NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
  fav_character VARCHAR(100),
  least_fav_character VARCHAR(100),
  soundtrack_notes TEXT,
  tags TEXT[]
);

CREATE TABLE watchlist (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  media_id UUID NOT NULL REFERENCES media_cache(id) ON DELETE CASCADE,
  status VARCHAR(20) DEFAULT 'quero_ver' CHECK (status IN ('quero_ver', 'assistindo', 'assistido')),
  added_at TIMESTAMP DEFAULT NOW(),
  UNIQUE (user_id, media_id)
);