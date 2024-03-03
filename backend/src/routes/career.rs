use axum::{extract::Extension, Json};
use serde::{Deserialize, Serialize};
use sqlx::PgPool;

#[derive(Serialize, Deserialize)]
pub struct Career {
    id: i32,
    name: String,
    years_from: String,
    years_to: String,
    description: String,
}

#[tracing::instrument(name = "reading careers data")]
pub async fn careers(Extension(pool): Extension<PgPool>) -> Json<Vec<Career>> {
    let result = sqlx::query!("select * from career where userid = $1", 1)
        .fetch_all(&pool)
        .await;

    let mut v = vec![];
    match result {
        Ok(rows) => {
            for row in rows {
                let years_to = match row.years_to {
                    Some(years_to) => years_to.to_string(),
                    None => "".to_string(),
                };
                v.push(Career {
                    id: row.id,
                    name: row.name,
                    years_from: row.years_from.to_string(),
                    years_to,
                    description: row.description,
                });
            }
            Json(v)
        }
        Err(err) => {
            tracing::error!("Failed to read about data {:?}", err);
            Json(v)
        }
    }
}
