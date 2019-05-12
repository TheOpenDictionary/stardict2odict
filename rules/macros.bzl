# load("@bazel_tools//tools/build_defs/repo:http.bzl", "new_http_archive")
load("@bazel_tools//tools/build_defs/repo:java.bzl", "java_import_external")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def remote_jar(name, hash, deps = [], artifact = None, url = None):
    if artifact == None and url == None:
        fail("You must specify either an artifact or url to use remote_jar")

    urls = []

    if artifact != None: 
        split = artifact.split(":")

        group = split[0]
        lib = split[1]
        version = split[2]

        path = "%s/%s/%s/%s-%s.jar" % (group.replace(".", "/"), lib, version, lib, version)

        urls = [
            "http://bazel-mirror.storage.googleapis.com/repo1.maven.org/maven2/%s" % path,
            "http://repo1.maven.org/maven2/%s" % path,
            "http://maven.ibiblio.org/maven2/%s" % path,
        ]

    java_import_external(
        name = name,
        licenses = ["notice"],
        jar_sha256 = hash,
        jar_urls = urls if url == None else [url]
    )

def remote_zipped_jar(name, url, hash, jar, strip_prefix, deps = []):
    http_archive(
        name = name, 
        build_file_content = '\n'.join([
            "package(default_visibility = [\"//visibility:public\"])",
            "",
            "java_import(",
            "    name = \"%s\","%name,
            "    jars = [\"%s\"],"%jar,
            ")"
        ]), 
        workspace_file_content = "workspace(name = \"%s_workspace\")"%name,
        urls=[url],
        sha256 = hash, 
        strip_prefix = strip_prefix
    )