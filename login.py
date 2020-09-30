#! C:\Python38-32\python.exe -u

import cgi, cgitb, re, hashlib, os, mysql.connector as mysql


def valid_account(uname, psw):
    """
    Checks if a valid username and password was entered
    """
    global errmsgs
    errors = 0  # keeps track of all the errors that have been

    try:
        unmelen = len(uname.strip())

        # Username validation
        if unmelen == 0:
            errors = errors + 1
            errmsgs.append("        <p>Username was not entered</p>")
        elif unmelen < 4:
            errors = errors + 1
            errmsgs.append(
                "        <p>Username should be at least 4 characters long</p>"
            )
    except AttributeError:
        errors = errors + 1
        errmsgs.append("        <p>Username was not entered</p>")

    try:
        pswlen = len(psw.strip())
        wschar = re.search("\s", psw)  # checks for any whitespace characters
        digits = re.search("\d{1,}", psw)  # checks for 1 or more digits

        # Password validation
        if pswlen == 0:
            errors = errors + 1
            errmsgs.append("        <p>Password was not entered</p>")
        elif pswlen < 8 or wschar or not digits:
            errors = errors + 1
            errmsgs.append(
                "        <p>Password should be at least 8 characters long and contain no whitespace characters and at least 1 digit</p>"
            )
    except AttributeError:
        errors = errors + 1
        errmsgs.append("        <p>Password was not entered</p>")

    return errors


# function for MySQL database processing code goes here


cgitb.enable()  # for debugging
# Intializes an empty list of error messages
errmsgs = []
form = cgi.FieldStorage()

# Username and Password Validation
if "uname" in form and "psw" in form:
    uname = form.getvalue("uname")
    psw = form.getvalue("psw")
else:
    if "uname" not in form:
        uname = ""
        psw = form.getvalue("psw")
    if "psw" not in form:
        uname = form.getvalue("uname")
        psw = ""

errctr = valid_account(uname, psw)

print("Content-Type: text/html")

if errctr == 0:
    # Sets the new location (URL) to the index.html page
    # print("Location: http://localhost/vote-project/index.html")
    print()

    # call to MySQL database processing function

    # For when the page is beeing redirecting
    print("<!DOCTYPE html5>")
    print('<html lang="en">')
    print("  <head>")
    print("    <title>Login</title>")
    print('    <link rel="stylesheet" href="css/login.css" />')
    print("  </head>")
    print("  <body>")
    print('    <div id="container">')
    print('      <div id="content">')
    print("        <h1>Redirecting...</h1>")
    print(
        '        <a href="index.html">Click here if you are still being redirected</a>'
    )
    print("      </div>")
    print("    </div>")
    print("  </body>")
    print("</html>")
else:
    # Printed when invalid usernames and/or passwords are entered
    print()  # adds a blank line since a blank line needs to follow the Content-Type
    print("<!DOCTYPE html5>")
    print('<html lang="en">')
    print("  <head>")
    print("    <title>Login</title>")
    print('    <link rel="stylesheet" href="css/login.css" />')
    print("  </head>")
    print("  <body>")
    print('    <div id="container">')
    print('      <div id="content">')
    print("        <h1>Error</h1>")

    # Prints any error messages when an invalid username or password is entered
    for i in range(errctr):
        print(errmsgs[i])

    print('        <a href="login.html">Click here fix your mistakes</a>')
    print("      </div>")
    print("    </div>")
    print("  </body>")
    print("</html>")