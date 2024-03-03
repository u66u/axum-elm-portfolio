use axum::{extract::Extension, Json};
use serde::Serialize;
use sqlx::PgPool;

#[derive(Serialize)]
pub struct Skill {
    id: i32,
    title: String,
    content: String,
}

#[tracing::instrument(name = "reading all skills (new)")]
pub async fn skills(Extension(pool): Extension<PgPool>) -> Json<Vec<Skill>> {
    let result = sqlx::query_as!(Skill, "SELECT id, content, title FROM skill")
        .fetch_all(&pool)
        .await;

    match result {
        Ok(blog) => Json(blog),
        Err(err) => {
            tracing::error!("Failed to read blog posts: {:?}", err);
            Json(vec![]) // Return an empty vector in case of error
        }
    }
}
