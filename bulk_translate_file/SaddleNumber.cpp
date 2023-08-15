#include<iostream>
#include<iomanip>
#include<cstdlib>
#include<cmath>
#include<ctime>
using namespace std;
#include<conio.h>\ pnint main(int agec,char *agev[])
{
	short **a;
	short M,N;
	short i,j;
\ jtsrand(time(0));
	cout<<" Matrix size: "<<endl;
	cout<<" Line: "<<flush;
	cin>>M;
	a=(short**)malloc(sizeof(short*)*M) ;
	cout<<"Column:"<<flush;
	cin>>N;
	for(i=0;i<M;i++)
	*(a+i)=( short*)malloc(sizeof(short)*N);
	for(i=0;i<M;i++)
	{
		for(j=0;j<N;j++) 
		{
			*(*(a+i)+j)=((rand()%5==0)?(-1):(1))*( rand()%100);
		}
	}
	clrscr();
	cout<<" The automatically generated matrix is: "<<endl<<endl;
	for(i=0;i<M;i++)
	{
		for(j=0;j<N;j++) 
		{
			cout<<setw(6)<<a[i][j];
		}
		cout<<endl<<endl <<endl;
	}
	return 0;
}
