def getUserInput():
    userInput = input("Please tell me your name: ")
    return userInput

def createGreeting(greeting):
    return "Hello {}".format(greeting)

def printGreetingToStdout(greeting):
    print(greeting)

if __name__ == "__main__":
    userInput = getUserInput()
    greeting = createGreeting(userInput)
    printGreetingToStdout(greeting)