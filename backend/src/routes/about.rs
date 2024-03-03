use axum::{extract::Extension, Json};
use serde::Serialize;
use sqlx::PgPool;

#[derive(Serialize)]
pub struct About {
    id: i32,
    text: String,
}

#[tracing::instrument(name = "reading about data")]
pub async fn about(Extension(pool): Extension<PgPool>) -> Json<About> {
    let result = sqlx::query!("select * from about where userid = $1", 1)
        .fetch_one(&pool)
        .await;
    match result {
        Ok(about) => Json(About {
            id: about.id,
            text: about.description,
        }),
        Err(err) => {
            tracing::error!("Failed to read about data {:?}", err);
            Json(About {
                id: 0,
                text: "".to_string(),
            })
        }
    }
}
