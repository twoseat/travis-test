package sessions;

import org.springframework.http.StreamingHttpOutputMessage;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;

@RestController
final class ApplicationController {

    @RequestMapping("/")
    String health() {
        return "ok";
    }

    @RequestMapping(value = "/session", method = RequestMethod.POST)
    void sessionDataStore(HttpSession session, @RequestBody String body) {
        session.setAttribute("testVariable", body);
    }

    @RequestMapping(value = "/session", method = RequestMethod.GET)
    Object sessionDataRetrieve(HttpSession session) {
        return session.getAttribute("testVariable");
    }
}