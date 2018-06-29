sub vcl_recv {
   if (req.http.host ~ "^([-0-9a-zA-Z]+)\.([a-zA-Z]+)$") {
        return (synth (750, ""));
   }
}

sub vcl_synth {
   if (resp.status == 750) {
        set resp.status = 301;
        set resp.http.Location = "http://www." + req.http.host + req.url;
        return(deliver);
   }
}
