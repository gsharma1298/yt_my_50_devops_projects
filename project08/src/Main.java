
import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;

public class Main {
    public static void main(String[] args) throws Exception {

        HttpServer server = HttpServer.create(
            new InetSocketAddress("0.0.0.0", 8080), 0
        );

        server.createContext("/", exchange -> {
            String html = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>HR82 DevOps</title>
                    <style>
                        body {
                            margin: 0;
                            min-height: 100vh;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            text-align: center;
                            font-family: Arial, sans-serif;
                            background: #ffffff;
                        }
                        h1 {
                            font-size: clamp(42px, 8vw, 90px);
                            font-weight: 900;
                            color: #1749c5;
                            margin-bottom: 20px;
                        }
                        h2 {
                            font-size: 24px;
                            color: #222222;
                        }
                        p {
                            font-size: 18px;
                            color: #666666;
                        }
                    </style>
                </head>
                <body>
                    <div>
                        <h1>HR82 DevOps</h1>
                        <h2>Welcome to HR 82 DevOps - Project 8</h2>
                        <p>Current date: %s</p>
                    </div>
                </body>
                </html>
                """.formatted(LocalDateTime.now());

            byte[] response = html.getBytes(StandardCharsets.UTF_8);

            exchange.getResponseHeaders().set(
                "Content-Type", "text/html; charset=UTF-8"
            );
            exchange.sendResponseHeaders(200, response.length);

            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response);
            }
        });

        server.start();
        System.out.println("HR82 DevOps server started on port 8080");
    }
}
