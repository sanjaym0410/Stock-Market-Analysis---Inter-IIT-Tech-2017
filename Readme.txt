Requirements:
Python 3.4
R

Steps:
1) Run build.sh
2) Run stock.py
3) Copy the output
4) Run google_news_final.py
	- Input : Please insert the stock codes obtained from running stock.py in the following format ['stock code'] (e.g. ['GS']). Please input only 1 code at a time
	- Output : test.csv
	- Four test.csv should be obtained till this step. 1 csv for each stock code.
Please follow the following process for each of the above obtained csv's:
1) Run test_df.R
2) Run modelling.R [Ensure train_data.RData is in the same working directory as modelling.R]
	- Output : stock_code.csv { Final result for one of the stock code}

Please repeat the above process for the remianing three test.csv files also
