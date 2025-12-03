Local environment configuration
=================================

This project expects the Adafruit IO key to be provided locally, not committed to the repository.

Quickstart (Windows PowerShell):

1. Copy the example .env:

   cp .env.example .env

2. Edit `.env` and put your real Adafruit IO key (this file is gitignored):

   AIO_KEY=your_real_aio_key_here

3. Run the generator to create `config.js` from `.env`:

   .\gen-config.ps1

   This will write `config.js` which defines `window.CONFIG = { AIO_KEY: '...' }`.

4. Open `index.html` in a browser (served by a simple local server) or use your usual dev server.

Notes:
- Never commit `.env` or `config.js` containing real secrets. They are listed in `.gitignore`.
- For production, do not embed secret keys in client-side code. Move API calls to a server-side proxy where the key is kept secret.