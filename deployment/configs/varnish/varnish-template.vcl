backend $PROJECT_NAME {
    .host = "127.0.0.1";
    .port = "80";
}
sub vcl_recv {
    if (req.http.host == "$PROJECT_NAME") {
        set req.http.host = "$PROJECT_NAME";
        set req.backend_hint = $PROJECT_NAME;
    }
}
