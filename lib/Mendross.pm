package Mendross;
use Dancer2;


our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'Mendross' };
};

post '/cross' => sub {
  my $genes = -1;
  $genes = body_parameters->get('gene');
  my $p_one = body_parameters->get('pog');
  my $p_two = body_parameters->get('ptg');


  ##############################################################
  # Mendross core logic (https://github.com/ElRakabawi/Mendross)
  ##############################################################


  #Formatting function for displaying offspring genotype properly
  sub format_swap {
  my ($geno) = @_;
  my $new_geno;

  my $len = length($geno);

  for(my $i=0; $i<$len; $i+=2){
    my $chunk = substr($geno, $i, 2);
    my $first = substr($chunk, 0, 1);
    my $second = substr($chunk, 1, 1);

    if($second lt $first){
      my $temp = $second;
      $second = $first;
      $first = $temp;
      $chunk = $first.$second;
    }

     $new_geno .= $chunk;
  }

  return $new_geno;
  }


  my $len_one = length($p_one); #length of Parent one genotype
  my $len_two = length($p_two); #length of Parent two genotype
  my $alleles = $genes*2; #Number of alleles

  if($len_one >= 2 && $len_two >= 2 ){

    my @POG = (); #Parent One Gametes
    my @PTG = (); #Parent Two Gametes
    my @POS = (); #Parent one step
    my @PTS = (); #Parent two step

    #Computation of monohybrid crossing
    if($genes == 1){
      for(my $i=0; $i<$alleles; $i++){
        $POG[$i] = substr($p_one,$i,1);
        $PTG[$i] = substr($p_two,$i,1);
      }

      my $rows = [
          ["  ",$POG[0], $POG[1]],
          [ $PTG[0], $PTG[0].$POG[0], $PTG[0].$POG[1] ],
          [ $PTG[1], $PTG[1].$POG[0], $PTG[1].$POG[1] ]
          ];

      for(my $y=1; $y<3; $y++){
        for(my $z=1; $z<3; $z++){
          $rows->[$y][$z] = format_swap($rows->[$y][$z]);
        }
      }


      #Pushing to the template 'monotable.tt'
        template 'monotable' => {
          'r00' => $rows->[0][0],
          'r01' => $rows->[0][1],
          'r02' => $rows->[0][2],
          'r10' => $rows->[1][0],
          'r11' => $rows->[1][1],
          'r12' => $rows->[1][2],
          'r20' => $rows->[2][0],
          'r21' => $rows->[2][1],
          'r22' => $rows->[2][2]
       };
    }
    # END #

    #Computation of Dihybrid crossing
    elsif ($genes == 2){
      for(my $i=0; $i<$alleles; $i++){
        $POS[$i] = substr($p_one,$i,1);
        $PTS[$i] = substr($p_two,$i,1);
      }

      my $m = 0;
      for(my $i=0; $i<$alleles; $i+=2){

        $POG[$i][0] = $POS[$m];
        $POG[$i][1] = $POS[2];
        $POG[$i+1][0] = $POS[$m];
        $POG[$i+1][1] = $POS[3];
        $m++;
      }

      my $n = 0;
      for(my $i=0; $i<$alleles; $i+=2){

        $PTG[$i][0] = $PTS[$n];
        $PTG[$i][1] = $PTS[2];
        $PTG[$i+1][0] = $PTS[$n];
        $PTG[$i+1][1] = $PTS[3];
        $n++;
      }


      my $rows = [
          #header rows
                ["  ",("$POG[0][0]"."$POG[0][1]"), ("$POG[1][0]"."$POG[1][1]"),("$POG[2][0]"."$POG[2][1]"), ("$POG[3][0]"."$POG[3][1]"),],
          #rows
          [ "$PTG[0][0]"."$PTG[0][1]", $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1], $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1],
          $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1], $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1] ], #row 1
          [ "$PTG[1][0]"."$PTG[1][1]", $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1], $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1],
          $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1], $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1] ], #row 2
          [ "$PTG[2][0]"."$PTG[2][1]", $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1], $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1],
          $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1], $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1] ], #row 3
          [ "$PTG[3][0]"."$PTG[3][1]", $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1], $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1],
          $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1], $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1] ], #row 4

        ];


        for(my $y=1; $y<5; $y++){
          for(my $z=1; $z<5; $z++){
            $rows->[$y][$z] = format_swap($rows->[$y][$z]);
          }
        }




      #Pushing to the template 'ditable.tt'
        template 'ditable' => {
          'r00' => $rows->[0][0],
          'r01' => $rows->[0][1],
          'r02' => $rows->[0][2],
          'r03' => $rows->[0][3],
          'r04' => $rows->[0][4],

          'r10' => $rows->[1][0],
          'r11' => $rows->[1][1],
          'r12' => $rows->[1][2],
          'r13' => $rows->[1][3],
          'r14' => $rows->[1][4],

          'r20' => $rows->[2][0],
          'r21' => $rows->[2][1],
          'r22' => $rows->[2][2],
          'r23' => $rows->[2][3],
          'r24' => $rows->[2][4],

          'r30' => $rows->[3][0],
          'r31' => $rows->[3][1],
          'r32' => $rows->[3][2],
          'r33' => $rows->[3][3],
          'r34' => $rows->[3][4],

          'r40' => $rows->[4][0],
          'r41' => $rows->[4][1],
          'r42' => $rows->[4][2],
          'r43' => $rows->[4][3],
          'r44' => $rows->[4][4],

       };
    }
    # END #

    #Computation of Trihybrid crossing
    elsif($genes == 3) {
    for(my $i=0; $i<$alleles; $i++){
      $POS[$i] = substr($p_one,$i,1);
      $PTS[$i] = substr($p_two,$i,1);
    }

    my $m = 0;
    for(my $i=0; $i<$alleles; $i+=2){

      $POG[$i][0] = $POS[$m];
      $POG[$i][1] = $POS[2];
      $POG[$i+1][0] = $POS[$m];
      $POG[$i+1][1] = $POS[3];
      $m++;
    }

    my $n = 0;
    for(my $i=0; $i<$alleles; $i+=2){

      $PTG[$i][0] = $PTS[$n];
      $PTG[$i][1] = $PTS[2];
      $PTG[$i+1][0] = $PTS[$n];
      $PTG[$i+1][1] = $PTS[3];
      $n++;
    }


    my $rows = [
        #header rows
              ["  ",
              ("$POG[0][0]"."$POG[0][1]"."$POS[4]"), #col 1
              ("$POG[0][0]"."$POG[0][1]"."$POS[5]"), #col 2
              ("$POG[1][0]"."$POG[1][1]"."$POS[4]"), #col 3
              ("$POG[1][0]"."$POG[1][1]"."$POS[5]"), #col 4
              ("$POG[2][0]"."$POG[2][1]"."$POS[4]"), #col 5
              ("$POG[2][0]"."$POG[2][1]"."$POS[5]"), #col 6
              ("$POG[3][0]"."$POG[3][1]"."$POS[4]"), #col 7
              ("$POG[3][0]"."$POG[3][1]"."$POS[5]"), #col 8
              ],
        #rows
        [
        "$PTG[0][0]"."$PTG[0][1]"."$PTS[4]", #row 1
        $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[4].$POS[4], #r1-c1
        $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[4].$POS[5], #r1-c2
        $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1].$PTS[4].$POS[4], #r1-c3
        $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1].$PTS[4].$POS[5], #r1-c4
        $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1].$PTS[4].$POS[4], #r1-c5
        $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1].$PTS[4].$POS[5], #r1-c6
        $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1].$PTS[4].$POS[4], #r1-c7
        $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1].$PTS[4].$POS[5]  #r1-c8
        ],
        [
        "$PTG[0][0]"."$PTG[0][1]"."$PTS[5]", #row 2
        $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[5].$POS[4], #r2-c1
        $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1].$PTS[5].$POS[5], #r2-c2
        $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1].$PTS[5].$POS[4], #r2-c3
        $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1].$PTS[5].$POS[5], #r2-c4
        $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1].$PTS[5].$POS[4], #r2-c5
        $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1].$PTS[5].$POS[5], #r2-c6
        $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1].$PTS[5].$POS[4], #r2-c7
        $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1].$PTS[5].$POS[5]  #r2-c8
        ],
        [
        "$PTG[1][0]"."$PTG[1][1]"."$PTS[4]", #row 3
        $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[4].$POS[4], #r3-c1
        $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[4].$POS[5], #r3-c2
        $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1].$PTS[4].$POS[4], #r3-c3
        $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1].$PTS[4].$POS[5], #r3-c4
        $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1].$PTS[4].$POS[4], #r3-c5
        $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1].$PTS[4].$POS[5], #r3-c6
        $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1].$PTS[4].$POS[4], #r3-c7
        $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1].$PTS[4].$POS[5]  #r3-c8
        ],
        [
        "$PTG[1][0]"."$PTG[1][1]"."$PTS[5]", #row 4
        $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[5].$POS[4], #r4-c1
        $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1].$PTS[5].$POS[5], #r4-c2
        $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1].$PTS[5].$POS[4], #r4-c3
        $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1].$PTS[5].$POS[5], #r4-c4
        $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1].$PTS[5].$POS[4], #r4-c5
        $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1].$PTS[5].$POS[5], #r4-c6
        $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1].$PTS[5].$POS[4], #r4-c7
        $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1].$PTS[5].$POS[5]  #r4-c8
        ],
        [
        "$PTG[2][0]"."$PTG[2][1]"."$PTS[4]", #row 5
        $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[4].$POS[4], #r5-c1
        $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[4].$POS[5], #r5-c2
        $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1].$PTS[4].$POS[4], #r5-c3
        $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1].$PTS[4].$POS[5], #r5-c4
        $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1].$PTS[4].$POS[4], #r5-c5
        $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1].$PTS[4].$POS[5], #r5-c6
        $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1].$PTS[4].$POS[4], #r5-c7
        $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1].$PTS[4].$POS[5]  #r5-c8
        ],
        [
        "$PTG[2][0]"."$PTG[2][1]"."$PTS[5]", #row 6
        $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[5].$POS[4], #r6-c1
        $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1].$PTS[5].$POS[5], #r6-c2
        $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1].$PTS[5].$POS[4], #r6-c3
        $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1].$PTS[5].$POS[5], #r6-c4
        $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1].$PTS[5].$POS[4], #r6-c5
        $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1].$PTS[5].$POS[5], #r6-c6
        $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1].$PTS[5].$POS[4], #r6-c7
        $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1].$PTS[5].$POS[5], #r6-c8
        ],
        [
        "$PTG[3][0]"."$PTG[3][1]"."$PTS[4]", #row 7
        $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[4].$POS[4], #r7-c1
        $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[4].$POS[5], #r7-c2
        $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1].$PTS[4].$POS[4], #r7-c3
        $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1].$PTS[4].$POS[5], #r7-c4
        $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1].$PTS[4].$POS[4], #r7-c5
        $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1].$PTS[4].$POS[5], #r7-c6
        $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1].$PTS[4].$POS[4], #r7-c7
        $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1].$PTS[4].$POS[5]  #r7-c8
        ],
        [
        "$PTG[3][0]"."$PTG[3][1]"."$PTS[5]", #row 8
        $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[5].$POS[4], #r8-c1
        $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1].$PTS[5].$POS[5], #r8-c2
        $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1].$PTS[5].$POS[4], #r8-c3
        $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1].$PTS[5].$POS[5], #r8-c4
        $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1].$PTS[5].$POS[4], #r8-c5
        $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1].$PTS[5].$POS[5], #r8-c6
        $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1].$PTS[5].$POS[4], #r8-c7
        $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1].$PTS[5].$POS[5]  #r8-c8
        ],

      ];


      for(my $y=1; $y<9; $y++){
        for(my $z=1; $z<9; $z++){
          $rows->[$y][$z] = format_swap($rows->[$y][$z]);
        }
      }

      #Pushing to the template 'tritable.tt'
        template 'tritable' => {
          'r00' => $rows->[0][0],
          'r01' => $rows->[0][1],
          'r02' => $rows->[0][2],
          'r03' => $rows->[0][3],
          'r04' => $rows->[0][4],
          'r05' => $rows->[0][5],
          'r06' => $rows->[0][6],
          'r07' => $rows->[0][7],
          'r08' => $rows->[0][8],

          'r10' => $rows->[1][0],
          'r11' => $rows->[1][1],
          'r12' => $rows->[1][2],
          'r13' => $rows->[1][3],
          'r14' => $rows->[1][4],
          'r15' => $rows->[1][5],
          'r16' => $rows->[1][6],
          'r17' => $rows->[1][7],
          'r18' => $rows->[1][8],

          'r20' => $rows->[2][0],
          'r21' => $rows->[2][1],
          'r22' => $rows->[2][2],
          'r23' => $rows->[2][3],
          'r24' => $rows->[2][4],
          'r25' => $rows->[2][5],
          'r26' => $rows->[2][6],
          'r27' => $rows->[2][7],
          'r28' => $rows->[2][8],

          'r30' => $rows->[3][0],
          'r31' => $rows->[3][1],
          'r32' => $rows->[3][2],
          'r33' => $rows->[3][3],
          'r34' => $rows->[3][4],
          'r35' => $rows->[3][5],
          'r36' => $rows->[3][6],
          'r37' => $rows->[3][7],
          'r38' => $rows->[3][8],

          'r40' => $rows->[4][0],
          'r41' => $rows->[4][1],
          'r42' => $rows->[4][2],
          'r43' => $rows->[4][3],
          'r44' => $rows->[4][4],
          'r45' => $rows->[4][5],
          'r46' => $rows->[4][6],
          'r47' => $rows->[4][7],
          'r48' => $rows->[4][8],

          'r50' => $rows->[5][0],
          'r51' => $rows->[5][1],
          'r52' => $rows->[5][2],
          'r53' => $rows->[5][3],
          'r54' => $rows->[5][4],
          'r55' => $rows->[5][5],
          'r56' => $rows->[5][6],
          'r57' => $rows->[5][7],
          'r58' => $rows->[5][8],

          'r60' => $rows->[6][0],
          'r61' => $rows->[6][1],
          'r62' => $rows->[6][2],
          'r63' => $rows->[6][3],
          'r64' => $rows->[6][4],
          'r65' => $rows->[6][5],
          'r66' => $rows->[6][6],
          'r67' => $rows->[6][7],
          'r68' => $rows->[6][8],

          'r70' => $rows->[7][0],
          'r71' => $rows->[7][1],
          'r72' => $rows->[7][2],
          'r73' => $rows->[7][3],
          'r74' => $rows->[7][4],
          'r75' => $rows->[7][5],
          'r76' => $rows->[7][6],
          'r77' => $rows->[7][7],
          'r78' => $rows->[7][8],

          'r80' => $rows->[8][0],
          'r81' => $rows->[8][1],
          'r82' => $rows->[8][2],
          'r83' => $rows->[8][3],
          'r84' => $rows->[8][4],
          'r85' => $rows->[8][5],
          'r86' => $rows->[8][6],
          'r87' => $rows->[8][7],
          'r88' => $rows->[8][8],



          'ifWorked' => 'Tri, tri .. Trihybrid Worked!'

       };
     }

  }

  else {
    template 'index' => {
      'noInput' => 'Please input a valid genotype.'
    }
  }





};

true;
