/*
 * Copyright © 2022 Ansh Gandhi
 *
 * This file is part of Rapid React Scorer.
 *
 * Rapid React Scorer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Rapid React Scorer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Rapid React Scorer.  If not, see <https://www.gnu.org/licenses/>.
 *
 * Original Author: Ansh Gandhi
 * Original Source Code: <https://github.com/anshgandhi4/RapidReactScorer>
 *
 * EVERYTHING ABOVE THIS LINE MUST BE KEPT AS IS UNDER GNU GPL LICENSE RULES.
 */

import 'package:flutter/material.dart';
import 'num.dart';

int aScore = 0;
int tScore = 0;
int pScore = 0;
int totalScore = 0;

Num _a1 = Num();
Num _a2 = Num();
Num _a3 = Num();

Num _t1 = Num();
Num _t2 = Num();
Num _t3 = Num();
Num _t4 = Num();
Num _t5 = Num();

Num _p1 = Num();
Num _p2 = Num();

Score score = Score();
SectionTitle aTitle = SectionTitle(title: 'Autonomous', update: getA);
SectionTitle tTitle = SectionTitle(title: 'Teleop', update: getT);
SectionTitle pTitle = SectionTitle(title: 'Penalties', update: getP);

Auto auto = Auto();
Teleop teleop = Teleop();
Penalty penalty = Penalty();
List modes = [Logo(), auto, teleop, penalty];
bool mobile = false;

void titleReset() {
  totalScore = aScore + tScore + pScore;
  score.rebuild();
  aTitle.rebuild();
  tTitle.rebuild();
  pTitle.rebuild();
}

int getA() {
  return aScore;
}

void setA(int newA) {
  aScore = newA;
  titleReset();
}

void calcA() {
  setA(2 * _a1.getInt() + 2 * _a2.getInt() + 4 * _a3.getInt());
}

int getT() {
  return tScore;
}

void setT(int newT) {
  tScore = newT;
  titleReset();
}

int calcHanging(int rung) {
  if (rung == 1) return 4;
  if (rung == 2) return 6;
  if (rung == 3) return 10;
  if (rung == 4) return 15;
  return 0;
}

void calcT() {
  setT(_t1.getInt() + 2 * _t2.getInt() + calcHanging(_t3.getInt()) + calcHanging(_t4.getInt()) + calcHanging(_t5.getInt()));
}

int getP() {
  return pScore;
}

void setP(int newP) {
  pScore = newP;
  titleReset();
}

void calcP() {
  setP(-4 * _p1.getInt() + -8 * _p2.getInt());
}

void main() => runApp(MaterialApp(
    home: Home()
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Rapid React Scorer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 8.0),
          score,
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: modes.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: modes[index],
                  margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Card(
                color: Colors.grey.shade300,
                elevation: 0.0,
                margin: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                child: const SizedBox(height: 5.0),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Brought to You By:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          const Text(
            'FRC Team 8404 Skywalkers',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}

class Score extends StatefulWidget {
  _ScoreState scoreState = _ScoreState();

  @override
  _ScoreState createState() {
    scoreState = _ScoreState();
    return scoreState;
  }

  void rebuild() {
    scoreState.rebuild();
  }
}

class _ScoreState extends State<Score> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Total Score: $totalScore',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10.0),
        IconButton(
          icon: const Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          tooltip: 'Reset',
          onPressed: () {
            if (mounted) {
              setState(() {
                auto.reset();
                teleop.reset();
                penalty.reset();
                calcA();
                calcT();
                calcP();
              });
            }
          },
        ),
      ],
    );
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }
}

class SectionTitle extends StatefulWidget {
  SectionTitle({Key? key, required this.title, required this.update}) : super(key: key);

  final String title;
  final Function update;

  _SectionTitleState sectionTitleState = _SectionTitleState();

  @override
  _SectionTitleState createState() {
    sectionTitleState = _SectionTitleState();
    return sectionTitleState;
  }

  void rebuild() {
    sectionTitleState.rebuild();
  }
}

class _SectionTitleState extends State<SectionTitle> {
  String title = '';
  Function update = () {};

  @override
  Widget build(BuildContext context) {
    title = widget.title;
    update = widget.update;

    return Text(
      '$title: ${update().toInt()}',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }
}

class CustomSlider extends StatefulWidget {
  CustomSlider({Key? key, required this.scorevar, required this.update, required this.minvar, required this.maxvar, this.parent}): super(key: key);

  final Num scorevar;
  final Function update;
  final double minvar;
  final double maxvar;
  final dynamic parent;

  _CustomSliderState customSliderState = _CustomSliderState();

  @override
  _CustomSliderState createState() => customSliderState;

  void rebuild() {
    customSliderState.rebuild();
  }
}

class _CustomSliderState extends State<CustomSlider> {
  late Num scorevar;
  late Function update;
  late double minvar;
  late double maxvar;
  dynamic parent;

  @override
  Widget build(BuildContext context) {
    scorevar = widget.scorevar;
    update = widget.update;
    minvar = widget.minvar;
    maxvar = widget.maxvar;
    parent = widget.parent;

    return SliderTheme(
      data: SliderThemeData(
        activeTickMarkColor: Colors.grey.shade200,
        activeTrackColor: Colors.grey.shade700,
        inactiveTickMarkColor: Colors.grey.shade300,
        inactiveTrackColor: Colors.grey.shade500,
        thumbColor: Colors.grey.shade800,
      ),
      child: SizedBox(
        width: 150.0,
        child: Slider(
          value: scorevar.get(),
          onChanged: (double value) {
            scorevar.set(value);
            update();
            if (mounted) {
              setState(() {
                scorevar.set(value);
              });
            }
          },
          min: minvar,
          max: maxvar,
          divisions: (maxvar - minvar).toInt(),
          label: '${scorevar.getInt()}',
        ),
      ),
    );
  }

  void rebuild() {
    if (mounted) {
      setState(() {
        update();
      });
    }
  }
}

class CustomButtonInput extends StatefulWidget {
  CustomButtonInput({Key? key, required this.scorevar, required this.update, this.parent}) : super(key: key);

  final Num scorevar;
  final Function update;
  final dynamic parent;

  _CustomButtonInputState customButtonInputState = _CustomButtonInputState();

  @override
  _CustomButtonInputState createState() => customButtonInputState;

  void rebuild() {
    customButtonInputState.rebuild();
  }
}

class _CustomButtonInputState extends State<CustomButtonInput> {
  late Num scorevar;
  late Function update;
  late int maxlength;
  dynamic parent;

  @override
  Widget build(BuildContext context) {
    scorevar = widget.scorevar;
    update = widget.update;
    parent = widget.parent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 54.0,
          child: MaterialButton(
            child: const Text('-1',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                )
            ),
            color: Colors.grey.shade800,
            elevation: mobile ? 4.0 : 8.0,
            onPressed: () {
              scorevar.setInt(scorevar.getInt() > 0 ? scorevar.getInt() - 1 : 0);
              update();
              if (mounted) {
                setState(() {});
              }
            },
            padding: EdgeInsets.all(mobile ? 15.0 : 20.0),
            shape: const CircleBorder(),
          ),
        ),
        const SizedBox(width: 5.0),
        SizedBox(
          width: 54.0,
          child: MaterialButton(
            child: const Text('+1',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                )
            ),
            color: Colors.grey.shade800,
            elevation: mobile ? 4.0 : 8.0,
            onPressed: () {
              scorevar.setInt(scorevar.getInt() + 1);
              update();
              if (mounted) {
                setState(() {});
              }
            },
            padding: EdgeInsets.all(mobile ? 15.0 : 20.0),
            shape: const CircleBorder(),
          ),
        ),
        const SizedBox(width: 5.0),
        Card(
          color: Colors.grey.shade700,
          elevation: mobile ? 4.0 : 8.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${scorevar.getInt()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15.0),
      ],
    );
  }

  void rebuild() {
    if (mounted) {
      setState(() {
        scorevar.setInt(0);
        update();
      });
    }
  }
}

class Logo extends StatefulWidget {
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/RapidReactLogo.png',
      height: 125,
      width: 125,
    );
  }
}

class Auto extends StatefulWidget {
  _AutoState autoState = _AutoState();

  @override
  _AutoState createState() {
    auto = this;
    autoState = _AutoState();
    return autoState;
  }

  void reset() {
    _a1.setInt(0);
    _a2.setInt(0);
    _a3.setInt(0);
    autoState.rebuild();
  }

  void rebuild() {
    autoState.rebuild();
  }
}

class _AutoState extends State<Auto> {
  late CustomSlider a1;
  late CustomButtonInput a2;
  late CustomButtonInput a3;

  @override
  Widget build(BuildContext context) {
    a1 = CustomSlider(scorevar: _a1, update: calcA, minvar: 0, maxvar: 3, parent: this);
    a2 = CustomButtonInput(scorevar: _a2, update: calcA, parent: this);
    a3 = CustomButtonInput(scorevar: _a3, update: calcA, parent: this);

    return Card(
      color: Colors.grey.shade900,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            aTitle,
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                a1,
                const Text(
                  'Robots Taxied',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                a2,
                const Text(
                  'Lower Hub Cargo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                a3,
                const Text(
                  'Upper Hub Cargo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }
}

class Teleop extends StatefulWidget {
  _TeleopState teleopState = _TeleopState();

  @override
  _TeleopState createState() {
    teleop = this;
    teleopState = _TeleopState();
    return teleopState;
  }

  void reset() {
    _t1.setInt(0);
    _t2.setInt(0);
    _t3.setInt(0);
    _t4.setInt(0);
    _t5.setInt(0);
    teleopState.rebuild();
  }

  void rebuild() {
    teleopState.rebuild();
  }
}

class _TeleopState extends State<Teleop> {
  late CustomButtonInput t1;
  late CustomButtonInput t2;
  late CustomSlider t3;
  late CustomSlider t4;
  late CustomSlider t5;

  @override
  Widget build(BuildContext context) {
    t1 = CustomButtonInput(scorevar: _t1, update: calcT, parent: this);
    t2 = CustomButtonInput(scorevar: _t2, update: calcT, parent: this);
    t3 = CustomSlider(scorevar: _t3, update: calcT, minvar: 0, maxvar: 4, parent: this);
    t4 = CustomSlider(scorevar: _t4, update: calcT, minvar: 0, maxvar: 4, parent: this);
    t5 = CustomSlider(scorevar: _t5, update: calcT, minvar: 0, maxvar: 4, parent: this);

    return Card(
      color: Colors.grey.shade900,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            tTitle,
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                t1,
                const Text(
                  'Lower Hub Cargo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                t2,
                const Text(
                  'Upper Hub Cargo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                t3,
                const Text(
                  'Robot 1 Rung Level',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                t4,
                const Text(
                  'Robot 2 Rung Level',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                t5,
                const Text(
                  'Robot 3 Rung Level',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }
}

class Penalty extends StatefulWidget {
  _PenaltyState penaltyState = _PenaltyState();

  @override
  _PenaltyState createState() {
    penalty = this;
    penaltyState = _PenaltyState();
    return penaltyState;
  }

  void reset() {
    _p1.setInt(0);
    _p2.setInt(0);
    penaltyState.rebuild();
  }

  void rebuild() {
    penaltyState.rebuild();
  }
}

class _PenaltyState extends State<Penalty> {
  late CustomButtonInput p1;
  late CustomButtonInput p2;

  @override
  Widget build(BuildContext context) {
    p1 = CustomButtonInput(scorevar: _p1, update: calcP, parent: this);
    p2 = CustomButtonInput(scorevar: _p2, update: calcP, parent: this);

    return Card(
      color: Colors.grey.shade900,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            pTitle,
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                p1,
                const Text(
                  'Foul          ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                p2,
                const Text(
                  'Tech Foul',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }
}
