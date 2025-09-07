import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CardFront extends StatelessWidget {
  final String rank; /// e.g. "A", "10", "K"
  final String suit; /// ♠ ♥ ♦ ♣
  final double height;

  const CardFront({
    super.key,
    required this.rank,
    required this.suit,
    this.height = 100
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;

    if(['♥', '♦', 'red'].contains(suit)){
      color = Color(0xFFE20F0F);
    }

    return SizedBox(
      height: height,
      child: AspectRatio(
        aspectRatio: 2.5 / 3.5, // standard poker card ratio
        child: Card(
          shape: height < 80 ?  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ): RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double fontSize = constraints.maxHeight * 0.3;
              if (rank == 'JOKER'){
                fontSize = fontSize * 0.7;
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'J',
                            style: GoogleFonts.inconsolata(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: color,
                                height: 0.7
                            ),
                          ),
                          Text(
                            'O',
                            style: GoogleFonts.inconsolata(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: color,
                                height: 0.7
                            ),
                          ),
                          Text(
                            'K',
                            style: GoogleFonts.inconsolata(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: color,
                                height: 0.7
                            ),
                          ),
                          Text(
                            'E',
                            style: GoogleFonts.inconsolata(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: color,
                                height: 0.7
                            ),
                          ),
                          Text(
                            'R',
                            style: GoogleFonts.inconsolata(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: color,
                                height: 0.7
                            ),
                          ),
                        ],
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SvgPicture.asset(
                            'assets/images/joker.svg',
                          height: fontSize * 3,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                      )


                    ],
                  ),
                );
              } else{
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rank,
                            style: GoogleFonts.inconsolata(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: color,
                                height: 1
                            ),
                          ),

                          Text(
                            suit,
                            style: GoogleFonts.inconsolata(
                                fontSize: fontSize,
                                color: color,
                                height: 0.4
                            ),
                          ),
                        ],
                      ),

                      if(rank == 'A' && suit == '♠') ...[
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: SvgPicture.asset(
                            'assets/images/ace_spades.svg',
                            width: fontSize * 1.5,
                            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                          ),
                        )
                      ] else
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Text(
                            suit,
                            style: GoogleFonts.inconsolata(
                                fontSize: fontSize * 3,
                                color: color,
                                height: 0.7
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
