use axum::http::HeaderValue;
use axum::{http::Method, routing::get, Extension, Router};
use backend::configuration::get_configuration;
use backend::routes::{
    about::about,
    blog::{all_blogs, blog_by_id},
    career::careers,
    skill::skills,
};
use dotenv::dotenv;
use sqlx::PgPool;
use std::env;
use tower_http::cors::CorsLayer;

#[tokio::main]
async fn main() {
    dotenv().ok();
    if std::env::var_os("RUST_LOG").is_none() {
        std::env::set_var("RUST_LOG", "info");
    }
    tracing_subscriber::fmt::init();

    let configuration = get_configuration().expect("Failed to read configuration.");
    let connection_pool = PgPool::connect_lazy(&configuration.database.connection_string())
        .expect("Failed to connect Postgres.");
    let address = format!("127.0.0.1:{}", configuration.application_port);
    let backend_url = env::var("BACKEND_URL").unwrap_or("http://localhost:1234".to_string());

    let app = Router::new()
        .route("/skills", get(skills))
        .route("/about", get(about))
        .route("/careers", get(careers))
        .route("/blog", get(all_blogs))
        .route("/blog/:id", get(blog_by_id))
        .layer(
            CorsLayer::new()
                .allow_origin(backend_url.parse::<HeaderValue>().unwrap())
                .allow_methods(vec![Method::GET]),
        )
        .layer(Extension(connection_pool));

    axum::Server::bind(&address.parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}
