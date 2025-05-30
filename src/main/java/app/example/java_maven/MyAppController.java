package app.example.java_maven;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MyAppController {

    @GetMapping("/myapp")
    public String hello() {
        return "Hello from /myapp!";
    }
}
