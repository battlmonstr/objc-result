load("@rules_cc//cc:defs.bzl", "objc_library")

_PUBLIC_HEADERS = [
    "OCResult.h",
    "OCResult+BlockAdapters.h",
]

objc_library(
    name = "lib",
    srcs = glob(
        [
            "**/*.h",
            "**/*.m",
        ],
        exclude = _PUBLIC_HEADERS,
    ),
    hdrs = _PUBLIC_HEADERS,
    visibility = ["//visibility:public"],
)
