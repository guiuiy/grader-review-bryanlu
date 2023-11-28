CPATH='".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

# check student code is correct file submitted
submission=`find student-submission -name "*.java"`
testFile=`find TestListExamples.java`

echo ""

if [[ ! -f $submission ]] || [[ ! $submission == **/ListExamples.java* ]]
then 
    echo "Wrong file or file name submitted"
    exit
fi

# get the student code and and move into grading-area
cp $submission grading-area/ListExamples.java
cp $testFile grading-area
cp -r lib grading-area

#run test
cd grading-area

javac -cp ".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar" *.java 2> compileError.txt
java -cp ".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar" org.junit.runner.JUnitCore TestListExamples > testResult.txt

grep "Failures:" testResult.txt > failureNumber.txt
failureText=`cat failureNumber.txt`
failureNumber=`wc -l failureNumber.txt`

if [[ $failureNumber == *1* ]]
then 
    readarray -d " " -t num <<< "$failureText"
    echo "There is at least" ${num[5]} "error:"

    compileErrorNumber=`wc -l compileError.txt`

    if [[ $compileErrorNumber != *0* ]]
    then
        echo "Compile error:"
        cat compileError.txt
    else
        echo "Failure:"
        cat testResult.txt
    fi

else
    echo "100%"
fi