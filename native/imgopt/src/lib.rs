use rustler::types::atom;
use rustler::NifUnitEnum;
use rustler::{Encoder, Env, Term};

#[derive(NifUnitEnum)]
enum ImageFormat {
    Jpeg,
    Jpg,
    Png,
    Webp,
    Svg,
}

impl From<ImageFormat> for imgopt_lib::Format {
    fn from(input: ImageFormat) -> imgopt_lib::Format {
        use ImageFormat::*;

        match input {
            Jpeg => imgopt_lib::Format::Jpeg,
            Jpg => imgopt_lib::Format::Jpeg,
            Png => imgopt_lib::Format::Png,
            Webp => imgopt_lib::Format::Webp,
            Svg => imgopt_lib::Format::Svg,
        }
    }
}

#[rustler::nif]
fn convert<'a>(env: Env<'a>, input: &str, output: &str) -> Term<'a> {
    match imgopt_lib::convert(input, output) {
        Ok(_) => atom::ok().encode(env),
        Err(e) => (atom::error(), e.to_string()).encode(env),
    }
}

#[rustler::nif]
fn convert_explicit<'a>(
    env: Env<'a>,
    input: &str,
    input_format: ImageFormat,
    output: &str,
    output_format: ImageFormat,
) -> Term<'a> {
    match imgopt_lib::convert_explicit((input, input_format.into()), (output, output_format.into()))
    {
        Ok(_) => atom::ok().encode(env),
        Err(e) => (atom::error(), e.to_string()).encode(env),
    }
}

rustler::init!("Elixir.Imgopt", [convert, convert_explicit]);
