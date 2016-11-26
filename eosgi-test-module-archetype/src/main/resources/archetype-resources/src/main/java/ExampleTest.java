package $package;

import org.junit.Test;
import org.osgi.framework.BundleContext;
import org.osgi.framework.FrameworkUtil;

import static org.junit.Assert.*;

public class ExampleTest {

    private final BundleContext context = FrameworkUtil.getBundle(ExampleTest.class).getBundleContext();

    @Test
    public void testExample() {
        // TODO
    }

}
