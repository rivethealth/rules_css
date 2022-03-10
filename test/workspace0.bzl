load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def test_repositories0():
    # Skylib

    SKYLIB_VERSION = "16de038c484145363340eeaf0e97a0c9889a931b"

    http_archive(
        name = "bazel_skylib",
        sha256 = "96e0cd3f731f0caef9e9919aa119ecc6dace36b149c2f47e40aa50587790402b",
        strip_prefix = "bazel-skylib-%s" % SKYLIB_VERSION,
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/%s.tar.gz" % SKYLIB_VERSION],
    )

    # File

    FILE_VERSION = "dfd8ba74af217a640f64605a9cfe08bcf1cc885a"

    http_archive(
        name = "rules_file",
        sha256 = "f6440ee964428778dc5a99044e8a876c2a87e4fb9a3b15aa17d8ebecea66708a",
        strip_prefix = "rules_file-%s" % FILE_VERSION,
        url = "https://github.com/rivethealth/rules_file/archive/%s.tar.gz" % FILE_VERSION,
    )

    # Protobuf

    PROTO_VERSION = "7e4afce6fe62dbff0a4a03450143146f9f2d7488"

    http_archive(
        name = "rules_proto",
        sha256 = "8e7d59a5b12b233be5652e3d29f42fba01c7cbab09f6b3a8d0a57ed6d1e9a0da",
        strip_prefix = "rules_proto-%s" % PROTO_VERSION,
        urls = ["https://github.com/bazelbuild/rules_proto/archive/%s.tar.gz" % PROTO_VERSION],
    )

    # Protobuf

    PROTO_GRPC_VERSION = "2.0.0"

    http_archive(
        name = "rules_proto_grpc",
        sha256 = "d771584bbff98698e7cb3cb31c132ee206a972569f4dc8b65acbdd934d156b33",
        strip_prefix = "rules_proto_grpc-%s" % PROTO_GRPC_VERSION,
        urls = ["https://github.com/rules-proto-grpc/rules_proto_grpc/archive/%s.tar.gz" % PROTO_GRPC_VERSION],
    )

    # JavaScript

    JAVACRIPT_VERSION = "39378f8f211cb98b76aa4a1f8daa08d1e10ad655"

    http_archive(
        name = "better_rules_javascript",
        sha256 = "878863262c52e05845137451963dae819927ceae6530da8e99df1a7923f4b3e5",
        strip_prefix = "rules_javascript-%s" % JAVACRIPT_VERSION,
        urls = [
            "https://github.com/rivethealth/rules_javascript/archive/%s.zip" % JAVACRIPT_VERSION,
        ],
    )
