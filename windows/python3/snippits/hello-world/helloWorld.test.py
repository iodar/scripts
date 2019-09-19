import unittest

from helloWorld import createGreeting

class HelloWorldTestcase(unittest.TestCase):
    """Does Hello World work?"""

    def test_hello_world_function(self):
        greeting = createGreeting("Dario")
        self.assertEqual(greeting, "Hello Dario", "The strings should match")

unittest.main()