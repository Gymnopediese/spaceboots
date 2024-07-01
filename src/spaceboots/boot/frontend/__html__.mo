import Array "mo:base/Array";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import valid "valid";
import invalid "invalid";
module {
        public type StatusCode = Nat16;
        public type HeaderField = (Text, Text);
        public type Request = {
            url : Text;
            method : Method;
            body : Blob;
            headers : [HeaderField];
        };
        public type Method = Text;
        public type Response = {
            body : Blob;
            headers : [HeaderField];
            status_code : StatusCode;
        };

    public func http_request(request : Request) : Response {
        let url = request.url;

        if (url == "/valid.html")
        {
            return ({
                body = valid.get_html();
                headers = [("Content-Type", "text/html")];
                status_code = 200;
            });
        };
        if (url == "/invalid.html")
        {
            return ({
                body = invalid.get_html();
                headers = [("Content-Type", "text/html")];
                status_code = 200;
            });
        };
        return ({
            body = Blob.fromArray([]);
            headers = [("Content-Type", "text/html")];
            status_code = 404;
        });
    }
}