package(default_visibility = ["//visibility:public"])

java_binary(
    name="stardict2odict",
    srcs=glob(["*.java"]),
    main_class="org.odict.stardict2odict.Main",
    deps=[
        "@com_fasterxml_jackson_annotations//jar",
        "@com_fasterxml_jackson_core//jar",
        "@com_fasterxml_jackson_databind//jar",
        "@com_fasterxml_jackson_dataformat_yaml//jar",
        "@commons_cli",
        "@org_apache_commons-compress//jar",
        "@org_apache_commons_lang3//jar",
        "@org_apache_commons_text//jar",
        "@org_dict_zip_dictzip//jar",
        "@com_vdurmont_emoji_java",
        "@org_json//jar",
        "@org_yaml_snakeyaml//jar",
    ]
)