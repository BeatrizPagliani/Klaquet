const express = require('express');
const router = express.Router();
const axios = require('axios');
require('dotenv').config();

const TMDB_BASE_URL = 'https://api.themoviedb.org/3';
const API_KEY = process.env.TMDB_API_KEY;

router.get('/search', async (req, res) => {
  const { query } = req.query;

  try {
    const response = await axios.get(`${TMDB_BASE_URL}/search/multi`, {
      params: {
        api_key: API_KEY,
        query,
        language: 'pt-BR',
      }
    });

    const results = response.data.results.filter(
      item => item.media_type === 'movie' || item.media_type === 'tv'
    );

    res.json(results);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao buscar na TMDB' });
  }
});

module.exports = router;