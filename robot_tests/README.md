# Synopsis

This project contains automated tests made for supermetrics.
The general story of how automated tests work and are run is as follows:

- Selenium2Library is used to control browsers.
- Python is used for ASCII conversion.
- Robot Framework is used to run tests and generates an HTML report.

# Pre-requirements

- Navigate to /robot_tests
- Open CMD and execute    pip install -r requirements.txt 

# Running Tests

- Tests can be run through CMD using the following command:  robot -i login_tests -i home_page_tests .\robot_tests\
- Here -i indicated the tags included in the run