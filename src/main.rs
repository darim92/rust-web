#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

extern crate chrono;

use rocket::http::RawStr;
use chrono::Local;


#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

#[get("/hello/<name>")]
fn hello(name: &RawStr) -> String {
    format!("Hello, {}!", name.as_str())
}

#[get("/time")]
fn get_time() -> String {
    format!("Localtime: {}!", Local::now())
}


fn main() {
    rocket::ignite().mount("/", routes![index, hello, get_time]).launch();
}