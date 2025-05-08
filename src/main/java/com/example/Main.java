package com.example;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

public class Main {
    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));

        Server server = new Server(port);

        WebAppContext context = new WebAppContext();
        context.setResourceBase("src/main/webapp");
        context.setContextPath("/");
        context.setParentLoaderPriority(true);

        context.setInitParameter("org.eclipse.jetty.servlet.Default.dirAllowed", "false");

        server.setHandler(context);
        server.start();
        server.join();
    }
}
