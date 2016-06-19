#!/usr/bin/perl


# classify.pl - list most significant words in a text
#               based on http://en.wikipedia.org/wiki/Tfidf

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 10, 2009 - first investigations; based on search.pl
# April 12, 2009 - added dynamic corpus

{
        no warnings;          # temporarily turn off warnings
        
        $x = $y + $z;         # I know these might be undef
}


# use/require
my @stopWords = qw (a about  above   above   across   after   afterwards
again   against   all   almost   alone   along   already   also  although
always  am  among   amongst   amoungst   amount    an   and   another   any
anyhow  anyone  anything  anyway   anywhere   are   around   as    at   back
be  became   because  become  becomes   becoming   been   before   beforehand
behind   being   below   beside   besides   between   beyond   bill   both
bottom  but   by   call   can   cannot   cant   co   con   could   couldnt   cryout.txt
de   describe   detail   do   done   down   due   during   each   eg   eight
either   eleven  else   elsewhere   empty   enough   etc   even   ever   every
everyone   everything   everywhere   except   few   fifteen   fify   fill   find
fire   first   five   for   former   formerly   forty found four from front full
further get give go had has hasnt have he hence her here hereafter hereby herein
hereupon hers herself him himself his how however hundred ie if in inc indeed interest
into is it its itself keep last latter latterly least less ltd made many may me meanwhile
might mill mine more moreover most mostly move much must my myself name namely neither
never nevertheless next nine no nobody none noone nor not nothing now nowhere of off often
on once one only onto or other others otherwise our ours ourselves out over ownpart per
perhaps please put rather re same see seem seemed seeming seems serious several she should
show side since sincere six sixty so some somehow someone something sometime sometimes
somewhere still such system take ten than that the their them themselves then thence there
thereafter thereby therefore therein thereupon these they thickv thin third this those
though three through throughout thru thus to together too top toward towards twelve twenty
two un under until up upon us very via was we well were what whatever when whence whenever
where whereafter whereas whereby wherein whereupon wherever whether which while whither who
whoever whole whom whose why will with within without would yet you your yours yourself
yourselves the);

require 'subroutines.pl';
my $AwellClassified=0;
my $GwellClassified=0;
my $Total=0;
my $numOfGraphicsFiles=0;
my $numOfAtheismFiles=0;
my $numOfAtheismTrainingFiles=0;
my $numOfGraphicsTrainingFiles=0;

# index, sans stopwords
my %index = ();

my @blockSixTrainingCorpus = <C:/Perl/20news-bydate/20news-bydate-train/6label/alt.atheism/*>;
foreach my $file (my @files) {
  #somehow the regular expression with backreference does not work here
  my @fileName=split(/\//, $file);
  my $fileNameLength=scalar(@fileName);
  print $file , "\n";
  open(INFILE, $file) or die "Cannot open $file: $!.\n";
  my @lines=<INFILE>;
  #rudimentarily cleaning the corpus
  my $lines=join(' ',@lines);
   $lines=~ s/From.*\n//;
   $lines=~ s/Subject.*\n//;
   $lines=~ s/Organization.*\n//;
   $lines=~ s/Lines.*\n//;
   $lines=~ s/Reply-to.*\n//;
   $lines=~ s/Reply-To.*\n//;
   $lines=~ s/In-Reply-to.*\n//;
   $lines=~ s/NNTP-Posting-Host.*\n//;
   $lines=~ s/Distribution.*//;
   $lines=~ s/In\sarticle.*writes:\n//;
   $lines=~ s/[`\>`]//;
   $lines=~ s/[`\>`][`\>`]//;
   $lines=lc($lines);
   $lines=~ s/\.//g;
   $lines=~ s/\?//g;
   $lines=~ s/\W/\ /g;
   $lines=~ s/\s(\s)+/ /g;
   $lines = join " ", map {lcfirst} split " ", $lines;
   my $blockSix=$blockSix.' '.$lines;
   $trainingFileHash{$fileName[$fileNameLength-1]}=$blockSix;
   $numOfAtheismFiles++;
   last if ($numOfAtheismFiles> 100);
}


my @blockOneTrainingCorpus = <C:/Perl/20news-bydate/20news-bydate-train/1label/comp.graphics/*>;
foreach my $file (@files) {
  #somehow the regular expression with backreference does not work here
  my @fileName=split(/\//, $file);
  my $fileNameLength=scalar(@fileName);
  print $file , "\n";
  open(INFILE, $file) or die "Cannot open $file: $!.\n";
  my @lines=<INFILE>;
  #rudimentarily cleaning the corpus
  my $lines=join(' ',@lines);
   $lines=~ s/From.*\n//;
   $lines=~ s/Subject.*\n//;
   $lines=~ s/Organization.*\n//;
   $lines=~ s/Lines.*\n//;
   $lines=~ s/Reply-to.*\n//;
   $lines=~ s/Reply-To.*\n//;
   $lines=~ s/In-Reply-to.*\n//;
   $lines=~ s/NNTP-Posting-Host.*\n//;
   $lines=~ s/Distribution.*//;
   $lines=~ s/In\sarticle.*writes:\n//;
   $lines=~ s/[`\>`]//;
   $lines=~ s/[`\>`][`\>`]//;
   $lines=lc($lines);
   $lines=~ s/\.//g;
   $lines=~ s/\?//g;
   $lines=~ s/\W/\ /g;
   $lines=~ s/\s(\s)+/ /g;
   $blockOne=$blockOne.' '.$lines;
   #print $lines, "\n";
   #print @processedLines;
   $trainingFileHash{$fileName[$fileNameLength-1]}=$blockOne;
   $numOfGraphicsFiles++;
   last if ($numOfGraphicsFiles> 100);  
}

my @blockSixTestCorpus = <C:/Perl/20news-bydate/20news-bydate-test/alt.atheism/*>;
foreach my $file (@blockSixTestCorpus) {
  #somehow the regular expression with backreference does not work here
  my @fileName=split(/\//, $file);
  my $fileNameLength=scalar(@fileName);
  print $file , "\n";
  open(INFILE, $file) or die "Cannot open $file: $!.\n";
  my @lines=<INFILE>;
  #rudimentarily cleaning the corpus
  my $lines=join(' ',@lines);
   $lines=~ s/From.*\n//;
   $lines=~ s/Subject.*\n//;
   $lines=~ s/Organization.*\n//;
   $lines=~ s/Lines.*\n//;
   $lines=~ s/Reply-to.*\n//;
   $lines=~ s/Reply-To.*\n//;
   $lines=~ s/In-Reply-to.*\n//;
   $lines=~ s/NNTP-Posting-Host.*\n//;
   $lines=~ s/Distribution.*//;
   $lines=~ s/In\sarticle.*writes:\n//;
   $lines=~ s/[`\>`]//;
   $lines=~ s/[`\>`][`\>`]//;
   $lines=lc($lines);
   $lines=~ s/\.//g;
   $lines=~ s/\?//g;
   $lines=~ s/\W/\ /g;
   $lines=~ s/\s(\s)+/ /g;
   $lines = join " ", map {lcfirst} split " ", $lines;
   $tblockOne=$tblockOne.' '.$lines;
    #print $lines, "\n";
   my @processedLines=split(/ /,$lines);
    #print @processedLines;
   $testFileHash{$fileName[$fileNameLength-1]}=$lines;
   $numOfAtheismTrainingFiles++;
   last if ($numOfAtheismTrainingFiles> 100);
}


my @blockTestCorpus = <C:/Perl/20news-bydate/20news-bydate-test/comp.graphics/*>;
foreach my $file (@blockTestCorpus) {
  #somehow the regular expression with backreference does not work here
  my @fileName=split(/\//, $file);
  my $fileNameLength=scalar(@fileName);
  print $file , "\n";
  open(INFILE, $file) or die "Cannot open $file: $!.\n";
  my @lines=<INFILE>;
  #rudimentarily cleaning the corpus
  my $lines=join(' ',@lines);
   $lines=~ s/From.*\n//;
   $lines=~ s/Subject.*\n//;
   $lines=~ s/Organization.*\n//;
   $lines=~ s/Lines.*\n//;
   $lines=~ s/Reply-to.*\n//;
   $lines=~ s/Reply-To.*\n//;
   $lines=~ s/In-Reply-to.*\n//;
   $lines=~ s/NNTP-Posting-Host.*\n//;
   $lines=~ s/Distribution.*//;
   $lines=~ s/In\sarticle.*writes:\n//;
   $lines=~ s/[`\>`]//;
   $lines=~ s/[`\>`][`\>`]//;
   $lines=lc($lines);
   $lines=~ s/\.//g;
   $lines=~ s/\?//g;
   $lines=~ s/\W/\ /g;
   $lines=~ s/\s(\s)+/ /g;
   $tblockSix=$tblockSix.' '.$lines;
   #print $lines, "\n";
   #print @processedLines;
   $testFileHash{$fileName[$fileNameLength-1]}=$lines;
   $numOfGraphicsTrainingFiles++;
   last if ($numOfGraphicsTrainingFiles> 100);
}



push @blockTrainingCorpus, @blockSixTrainingCorpus;
push @blockTrainingCorpus, @blockOneTrainingCorpus;


# index, sans stopwords


push (@blockTestCorpus, @blockSixTestCorpus);


foreach my $file ( @blockTrainingCorpus){
        $numOfFilesOne++;
        #print "  numOfFiles ", "$numOfFilesTwo", "\n";
}
my @Graphics;
my @Atheism;
my $numOfTestFiles=0;
my $simSum=0;

 
foreach my $file ( @blockTrainingCorpus){   
                if ($loops==0){
                       $CatRef=&createVector($file);
                        %Cat = %$CatRef;
                        $loops=1;     
                }
                 else{      
                        $loops++;
                        $numOfTestFiles++;
                        my @fileName=split(/\//, $file);
                        my $fileNameLength=scalar(@fileName);
                        #print "file ",  $fileName[$fil
                        #print "file ",  $fileName[$fileNameLength-1], "\n";
                        $index{$file}=&index($file);
                        &printIndex(\%index, $file);
                        #$trainingFileVector=&createVector($file);   
                        #%trainingFileHash=%$trainingFileVector;
                        my $cat=&addDocCat(\%index, $file, \%Cat);
                        $trainingAryCtr=0;
                        %cat=%$cat;
                        foreach my $word (keys %cat){
                                #print  "1 Test array filling up ", $word , "\n";
                                if ((&stopList(\@stopWords, $word)))  {
                                        $trainingAryCtr++;
                                        push (@trainingAry, $cat{$word});        
                                        last if ($trainingAryCtr > 10);
                                }
                        }
                 }
}
my @sortedTrainingAry= sort @trainingAry;

foreach my $file ( @blockTestCorpus){  
        $numOfTestFiles++;
        my @testFileName=split(/\//, $file);
        my $testFileNameLength=scalar(@testFileName);
        #print "file ",  $testFileName[$fileNameLength-1], "\n";
        $index{$file}=&index($file);
        &printIndex(\%index, $file);
        $testFileVector=&createVector($file);
        %testFileHash=%$testFileVector;
        foreach my $word (keys %testFileHash){
                        if ((&stopList(\@stopWords, $word)))  {
                                push (@testAry, $testFileHash{$word});        
                                #print  "1 Test array filling up ", $testFileHash{$word}, "\n";
                        }
        }
        my @sortedTrainingAry= sort @trainingAry;
        my $finalResult= cos(&dot([@sortedTrainingAry  ], [@testAry  ])/&euclidian( [@sortedTrainingAry  ] ) * &euclidian( [ @testAry ] )), "\n" if &euclidian( [@sortedTrainingAry  ] ) * &euclidian( [ @testAry ] ) != 0;
        print  "Similarity test file and training file:  ", "$finalResult ", "\n";
        if (($testFileName[$testFileNameLength-1] > 38758) && ($testFileName[$testFileNameLength-1] < 40062)) {
                $scoreTestFile_Graph=$finalResult;
                $scoreTestFile_Ath=0;
        }
        elsif (($testFileName[$testFileNameLength-1] > 53068) && ($testFileName[$testFileNameLength-1] < 54564)){
                $scoreTestFile_Ath=$finalResult;
                $scoreTestFile_Graph=0;
        }
        if (($scoreTestFile_Ath>$scoreTestFile_Graph)&&($testFileName[$testFileNameLength-1] > 53068) && ($testFileName[$testFileNameLength-1] < 54564)) {
                $atheismWellClassified++; 
        }
        if (($scoreTestFile_Graph>$scoreTestFile_Ath)&&($testFileName[$testFileNameLength-1] > 38758) && ($testFileName[$testFileNameLength-1] < 40062)) {
                $graphicsWellClassified++; 
        }
        undef(@testAry); 
}


print  "Correctly classified Graphics :  ", "$graphicsWellClassified ", "\n\n";
print  "Correctly classified Atheism :  ", "$atheismWellClassified ", "\n\n";
print  "Total num of files :  ", " $numOfTestFiles", "\n\n";                        
                        



sub dot {
  
    # dot product = (a1*b1 + a2*b2 ... ) where a and b are equally sized arrays (vectors)
    my $a = shift;
    my $b = shift;
    my $d = 0;
    for ( my $i = 0; $i <= $#$a; $i++ ) { $d = $d + ( $$a[ $i ] * $$b[ $i ] ) }
    return $d;
  }

sub euclidian {
  
    # Euclidian length = sqrt( a1^2 + a2^2 ... ) where a is an array (vector)
    my $a = shift;
    my $e = 0;
    for ( my $i = 0; $i <= $#$a; $i++ ) { $e = $e + ( $$a[ $i ] * $$a[ $i ] ) }
    return sqrt( $e );
  
  } 
  
sub stopList
{
my @stopWordList=@{$_[0]};
 my $word=${$_[1]};
 #print "DEBUG_DOWN1  *", $line, "*\n\n";
 my @newLine;
 foreach my $stopWord(@stopWordList){
        if ($stopWord eq $word){
                        #print "   ", $stopWord, "   ";
                return 0;
        }
        else{
                return 1;
        }
  }

}





    
    
