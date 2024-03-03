## Portfolio Backend Setup Instructions

1. **Start a Postgres Database Service** (Ensure psql and sqlx are installed):
   ```bash
   sudo systemctl start postgres.service
   ```

2. **Run Migrations**:
   ```bash
   chmod +x scripts/start.sh
   ./scripts/start.sh
   ```
   This will automatically populate the `configuration/local.yaml` and `.env` files with test database variables, as well as import some sample data into the postgres database. You can modify them as needed. Remember to set `APP_ENVIRONMENT='production'` in the `.env` file if launching the backend in production.

3. **(Optional) Set Environment Variables in `configuration/local.yaml`** (or `production.yaml` for production).

4. **(Optional) Set Environment Variables in `.env`**.

5. **Run the Server**:
   ```bash
   cargo run --release
   ```

6. **Run the Frontend**

The configuration folder has 3 files: base (config for all instances, no matter development or production), local (development config), production (production config). They are used depending on what env variable APP_ENVIRONMENT is set to.
