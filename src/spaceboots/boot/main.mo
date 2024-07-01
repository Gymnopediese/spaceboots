import Principal "mo:base/Principal";
import Http "mo:certified-cache/Http";
import Text "mo:base/Text";
import Error "mo:base/Error";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Frontend "frontend/__html__";
import Scan "scan";

shared ({ caller = creator }) actor class Boot() = this {

    type HttpRequest = Frontend.Request;
    type HttpResponse = Frontend.Response;

    stable var scan_count : Nat = 0;

    var name : Text = "Boot";

    public func http_request_update(request : Http.HttpRequest) : async Http.HttpResponse {
        let counter = Scan.scan(request.url, scan_count);
        if (counter > 0) {
            scan_count := counter;
        };
        return {
            body = Text.encodeUtf8("Scan Count: " # Nat.toText(scan_count));
            headers = [("Content-Type", "text/plain")];
            status_code = 200;
            streaming_strategy = null;
            upgrade = ?true;
        }
    };

    
    public query func http_request(request : Frontend.Request) : async Frontend.Response {


        try {
        let counter = Scan.scan(request.url, scan_count);

        Debug.print("Valid: " # Nat.toText(counter)# " Scan Count: " # Nat.toText(scan_count));
        let new_request = {
            url = if (counter > 0) {
                "/valid.html"
            } else {
                "/invalid.html"
            };
            method = request.method;
            body = request.body;
            headers = request.headers;
        };

        return (Frontend.http_request(new_request));
        } catch (err) {
            return ({
                body = Text.encodeUtf8("Error: " # Error.message(err));
                headers = [("Content-Type", "text/plain")];
                status_code = 500;
            });
        };
    };

};
