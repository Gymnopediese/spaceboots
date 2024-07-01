import Http "http";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Cycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";
import Float "mo:base/Float";
import Prim "mo:⛔";
actor Board {

    public type HttpRequest = Http.Request;
    public type HttpResponse = Http.Response;
    public type BootName = Text;
    public type BootCanister = Principal;
    public type RecordedTime = Time;
    public type Caller = Principal;
    public type Time = Time.Time;

    stable var logs : [(BootName, BootCanister, Caller, RecordedTime)] = [];

    public query func http_request(_request : HttpRequest) : async HttpResponse {
        return ({
            body = Text.encodeUtf8(
                "Open Internet Summer: Spaceboots .\n"
                # "---\n"
                # "Cycle Balance: " # Nat.toText(Cycles.balance() / 1_000_000_000_000) # "T\n"
                # "Heap size (current): " # Nat.toText(Prim.rts_heap_size()) # " bytes" # " ( " # Float.toText(Float.fromInt(Prim.rts_heap_size() / (1024 * 1024))) # "Mb" # " )\n"
                # "Heap size (max)" # Nat.toText(Prim.rts_max_live_size()) # " bytes" # " ( " # Float.toText(Float.fromInt(Prim.rts_max_live_size() / (1024 * 1024))) # "Mb" # " )\n"
                # "Memory size " # Nat.toText(Prim.rts_memory_size()) # " bytes" # " ( " # Float.toText(Float.fromInt(Prim.rts_memory_size() / (1024 * 1024))) # "Mb" # " )\n"
            );
            headers = [("Content-Type", "text/plain")];
            status_code = 200;
        });
    };

    // Add a daily check to the board
    // Can only be called once per hour per user
    // The name and mood should be less than 24 characters
    // Logs are stored in the logs array (in chronological order)
    public shared ({ caller }) func addToCollection(
        bootName : BootName,
        bootCanister : BootCanister,
    ) : async () {

        // Check if the name and mood are less than 24 characters
        if (bootName.size() > 48) {
            return;
        };

        // Check that the bootCanister is a valid principal
        if (Text.endsWith((Principal.toText(bootCanister)), #text("cai"))) {
            return;
        };

        let time = Time.now();
        logs := Array.append(logs, [(bootName, bootCanister, caller, time)]);
        return;
    };

};
