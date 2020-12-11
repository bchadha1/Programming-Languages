my $filename = "input.txt";

if(-e $filename && -r $filename)
{    
    open FILE, "$filename" or die $!;
    my $word;
    print("\n");
    while(<FILE>){
        $word = "$_";
        chomp($word);

        if($word=~m/or/){
            print "$word contains \"or\": \n";
        }
        
        if($word=~m/[aeiou][aeiou]+$/)
	{
            print "$word contains vowel characters: \n";
        }
        
	 # string that do not start with letter 'h'
        if($word=~m/^[^h]/){
            print "$Strings that do not start with H: \n";
        }
        
        if($word=~/^.e/ && $word=~/y$/){
            print "$String that have 'E' as the second symbol and end with 'Y': \n";
        }

	if($word=~/.^(?=.*[a-zA-Z])(?=.*[0-9])/)
	{
            print "$Words which contain both letters and digits: $word  \n";
        }

        print("\n\n");
        
    }#end of while loop
    
    close(FILE);
}

else
{
    print "$filename : file does not exist\n";
}
