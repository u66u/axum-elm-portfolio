use axum::{
    extract::{Extension, Path},
    Json,
};
use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::PgPool;

#[derive(Serialize, Deserialize)]
pub struct BlogPost {
    id: i32,
    name: String,
    content: String,
    created_at: NaiveDateTime,
}

#[tracing::instrument(name = "reading all blog posts")]
pub async fn all_blogs(Extension(pool): Extension<PgPool>) -> Json<Vec<BlogPost>> {
    let result = sqlx::query_as!(BlogPost, "SELECT * FROM blog")
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

#[tracing::instrument(name = "reading blog post by id")]
pub async fn blog_by_id(
    Path(id): Path<i32>,
    Extension(pool): Extension<PgPool>,
) -> Json<Option<BlogPost>> {
    let result = sqlx::query_as!(BlogPost, "SELECT * FROM blog WHERE id = $1", id)
        .fetch_optional(&pool)
        .await;

    match result {
        Ok(Some(blog)) => Json(Some(blog)),
        Ok(None) => {
            tracing::warn!("Blog post with id {} not found", id);
            Json(None) // Return None if no blog post is found
        }
        Err(err) => {
            tracing::error!("Failed to read blog post: {:?}", err);
            Json(None) // Return None in case of error
        }
    }
}
