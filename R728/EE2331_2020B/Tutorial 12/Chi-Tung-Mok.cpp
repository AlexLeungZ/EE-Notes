/*
 * Instructions:
 *
 * 1. Only complete the functions specified below. Do not create any additional function.
 * 2. Use Visual Studio 2019 to build, test and run your code.
 * 3. Do not include any additional header or library.
 * 
 * This exercise is about the use of the qsort() function available in the C++ stdlib.
 * An array of invoice will be generated by the main function as input.
 *
 */

#include <cstdlib>
#include <iostream>
#include <ctime>

using namespace std;

struct date {
	int year;
	int month;
	int day;
};

struct invoice {
	int amount;
	date date;
};

//-------------------------- functions to be implemented by you

/*
 * Overload the operator << for the date struct.
 * This operator prints the given date object in this format: yyyy-mm-dd, e.g. 2019-09-28
 */
ostream& operator<<(ostream& osObject, date& myDate) {
	return cout << myDate.year << "-" << myDate.month << "-" << myDate.day;
}

/* 
 * Overload the operator << for the invoice struct.
 * This operator prints the given invoice object in this format: $amount (yyyy-mm-dd), e.g. $1200 (2019-09-28)
 */
ostream& operator<<(ostream& osObject, invoice& myInvoice) {
	return cout << "$" << myInvoice.amount << " (" << myInvoice.date << ")";
}

/*
 * This function defines the order of two invoice objects.
 * It returns a +ve value if a's date is earlier than b's date.
 * It returns a -ve value if a's date is later than b's date.
 * It returns 0 if a's date is equal to b's date.
 */
int compareInvoiceDate(const void* a, const void* b) {

	invoice* invoice1 = (invoice*)a;
	invoice* invoice2 = (invoice*)b;

	if ((&invoice1->date)->year != (&invoice2->date)->year)
		return (&invoice2->date)->year - (&invoice1->date)->year;

	if ((&invoice1->date)->month != (&invoice2->date)->month)
		return (&invoice2->date)->month - (&invoice1->date)->month;

	return (&invoice2->date)->day - (&invoice1->date)->day;
}

/*
 * This function defines the order of two invoice objects.
 * It returns a +ve value if a's amount is greater than b's amount.
 * It returns a -ve value if a's amount is smaller than b's amount.
 * It returns a +ve value if a's amount is equal to b's amount but a's date is later than b's date.
 * It returns a -ve value if a's amount is equal to b's amount but a's date is earlier than b's date.
 * It returns 0 if a's amount and date is equal to b's amount and date.
 */
int compareInvoiceAmountDate(const void* a, const void* b) {

	invoice* invoice1 = (invoice*)a;
	invoice* invoice2 = (invoice*)b;

	if (invoice1->amount != invoice2->amount)
		return invoice1->amount - invoice2->amount;

	return -compareInvoiceDate(a, b);
}


//-------------------------- functions prepared for you

/*
 * Helper function to generate n random invoices
 */
void genInvoiceArray(invoice* list, int n) {
	
	for (int i = 0; i < n; i++)	{
		list[i].amount = 1000 + rand() % 5 * 100;
		list[i].date.year = 1900 + rand() % 120;
		list[i].date.month = 1 + rand() % 12;

		switch (list[i].date.month)
		{
		case 2: list[i].date.day = 1 + rand() % 28;
			break;
		case 4:
		case 6:
		case 9:
		case 11: list[i].date.day = 1 + rand() % 30;
			break;
		default: list[i].date.day = 1 + rand() % 31;
		}
	}
}

/*
 * Driver program
 *
 * Generate random input to test your functions' implementation.
 *
 */
int main() {

	srand((unsigned)time(NULL));

	int n = 10;
	invoice* list = new invoice[n];

	// initialize a list of invoices 
	genInvoiceArray(list, n);

	cout << "Before sorting:" << endl;
	for (int i = 0; i < n; i++)
		cout << list[i] << endl;
	cout << endl;

	//use qsort() to sort list[] by date in DESCENDING order
	cout << "Sort by date descendingly:" << endl;
	qsort(list, n, sizeof(invoice), compareInvoiceDate);
	for (int i = 0; i < n; i++)
		cout << list[i] << endl;
	cout << endl;

	//use qsort() to sort list[] by amount and date in ASCENDING order
	cout << "Sort by amount and date ascendingly:" << endl;
	qsort(list, n, sizeof(invoice), compareInvoiceAmountDate);
	for (int i = 0; i < n; i++)
		cout << list[i] << endl;
	cout << endl;

}


// *************************************************
/* Output example:

Before sorting:
$1200 (1935-08-21)
$1100 (1951-03-17)
$1300 (1977-05-05)
$1000 (2002-08-15)
$1400 (1930-01-16)
$1200 (1915-09-26)
$1300 (2018-02-16)
$1400 (1915-07-31)
$1300 (1954-06-07)
$1400 (1975-07-07)

Sort by date descendingly:
$1300 (2018-02-16)
$1000 (2002-08-15)
$1300 (1977-05-05)
$1400 (1975-07-07)
$1300 (1954-06-07)
$1100 (1951-03-17)
$1200 (1935-08-21)
$1400 (1930-01-16)
$1200 (1915-09-26)
$1400 (1915-07-31)

Sort by amount and date ascendingly:
$1000 (2002-08-15)
$1100 (1951-03-17)
$1200 (1915-09-26)
$1200 (1935-08-21)
$1300 (1954-06-07)
$1300 (1977-05-05)
$1300 (2018-02-16)
$1400 (1915-07-31)
$1400 (1930-01-16)
$1400 (1975-07-07)

*/