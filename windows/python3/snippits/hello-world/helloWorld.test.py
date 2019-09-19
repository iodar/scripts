import unittest
import sys
import io
import os

from helloWorld import createGreeting, getUserInput, printGreetingToStdout

class HelloWorldTestcase(unittest.TestCase):
    """Does Hello World work?"""

    def test_hello_world_function(self):
        # exec
        greeting = createGreeting("Dario")

        # assert
        self.assertEqual(greeting, "Hello Dario", "The strings should match")

    def test_user_input(self):
        # prep
        # save old stdout to var
        oldStdout = sys.stdout
        # redirect stdout to null
        # devnull is the null device for all supported operating systems
        devnull = open(os.devnull, 'w')
        # set stdout to device 'devnull'
        sys.stdout = devnull

        # redirect string to stdin (mocking user input)
        sys.stdin = io.StringIO("Dario\n")
        
        # exec
        userInput = getUserInput()

        # assert
        self.assertEqual(userInput, "Dario")

        # restore original redirection of stdout
        # and close devnull
        sys.stdout = oldStdout
        devnull.close()

    def test_printing_to_stdout(self):
        # prep
        # save old stdout to var
        oldStdout = sys.stdout
        # create string
        capturedStdout = io.StringIO()
        # redirect stdout to var
        sys.stdout = capturedStdout

        # exec
        printGreetingToStdout("Hello Dario")

        # assert
        # getting value of captured stdout
        # and stripping it from whitespaces and '\n', '\t' etc.
        actualStrippedStdout = str.strip(capturedStdout.getvalue())
        self.assertEqual(actualStrippedStdout, "Hello Dario")

        # restore original redirection of stdout
        sys.stdout = oldStdout

unittest.main()