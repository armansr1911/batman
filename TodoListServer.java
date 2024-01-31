import java.io.*;
import java.net.*;
import java.util.*;

public class TodoListServer {
    private static final int PORT = 12345;
    private static Map<String, List<String>> todoLists = new HashMap<>();
    private static Map<String, String> userCredentials = new HashMap<>();
    private static Map<String, Long> lastAccessTime = new HashMap<>();

    public static void main(String[] args) {
        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            System.out.println("Server started. Listening on port " + PORT);
            while (true) {
                Socket clientSocket = serverSocket.accept();
                System.out.println("Client connected: " + clientSocket);

                ClientHandler clientHandler = new ClientHandler(clientSocket);
                new Thread(clientHandler).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static class ClientHandler implements Runnable {
        private final Socket clientSocket;

        public ClientHandler(Socket clientSocket) {
            this.clientSocket = clientSocket;
        }

        @Override
        public void run() {
            try (BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
                 PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)) {

                String request;
                while ((request = in.readLine()) != null) {
                    String[] tokens = request.split(":");
                    String command = tokens[0];

                    switch (command) {
                        case "LOGIN":
                            String username = tokens[1];
                            String password = tokens[2];
                            if (userCredentials.containsKey(username) && userCredentials.get(username).equals(password)) {
                                out.println("LOGIN_SUCCESS");
                                lastAccessTime.put(username, System.currentTimeMillis());
                            } else {
                                out.println("LOGIN_FAILURE");
                            }
                            break;

                        case "SAVE_LIST":
                            username = tokens[1];
                            String listName = tokens[2];
                            String todoList = tokens[3];
                            if (userCredentials.containsKey(username)) {
                                todoLists.computeIfAbsent(username, k -> new ArrayList<>()).add(todoList);
                                out.println("LIST_SAVED");
                            } else {
                                out.println("USER_NOT_FOUND");
                            }
                            break;

                        case "GET_LIST":
                            username = tokens[1];
                            if (userCredentials.containsKey(username)) {
                                List<String> lists = todoLists.getOrDefault(username, new ArrayList<>());
                                out.println("YOUR_LISTS:" + String.join(",", lists));
                            } else {
                                out.println("USER_NOT_FOUND");
                            }
                            break;

                        case "LOGOUT":
                            username = tokens[1];
                            if (userCredentials.containsKey(username)) {
                                lastAccessTime.remove(username);
                                out.println("LOGOUT_SUCCESS");
                            } else {
                                out.println("USER_NOT_FOUND");
                            }
                            break;

                        default:
                            out.println("INVALID_COMMAND");
                            break;
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
