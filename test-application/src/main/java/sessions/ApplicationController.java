package sessions;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
final class ApplicationController {

    @RequestMapping("/")
    String health() {
        return "ok";
    }
}