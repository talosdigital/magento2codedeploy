sub vcl_recv {
   if (req.http.host ~ "^www\.") {
        return (synth (750, ""));
   }
}

sub vcl_synth {
    if (resp.status == 750) {
        set resp.status = 302;
        set resp.http.Location = "http://" + regsuball(req.http.host, "^www\.", "") + req.url;
        return(deliver);
    }
}