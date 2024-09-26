print ("Content-type: Text/html\n")
print("Cache-control: no-cache")
print("Pragma: no-cache")


-- This function is executed for every request
function handle(r)
    r.content_type = "text/html"
    r:puts("<html><body><h1>Hello from External Lua Script!</h1></body></html>")
    return apache2.OK
end
