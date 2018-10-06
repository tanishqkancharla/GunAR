# GunAR

GunAR is a game that replicates laser tag. It involves a gun and an app on the user's phone. It was completed as part of a project submitted by the creators to the Build18 hackathon. We thought of this idea while talking about how much fun laser tag is but how inconvenient it is to play (finding a laser tag place near you, making an appointment, putting on sensors etc.). So, to make that process easier, we started brainstorming ideas for how it could be made easier for everyone to play.

# What it does
GunAR, as we envisioned it, would consist of a set of guns. Each player is given a gun, and they load their phone into the holster. The phone has an app that connects to the gun through bluetooth and it uses data to detect positions of other players. When the trigger is pressed, the gun sends a signal to the phone, the phone determines using a raycast whether the "laser" landed in a bounding box around the position of the other phone. The phone app also has a single player mode where it shows enemies on the screen in Augmented Reality that you would shoot down to get points.

# How to use
To try our project, download the xcode project file. 

# How we built it
To build the app, we learned the basics of Swift. To implement the gun's technology, we used Raspberry Pi's. To connect through bluetooth to the phone, we also had to learn Javascript. Finally, for the hardware component, we designed and built a gun shell that had an adjustable holster to fit a phone and space for the RPi as well as a trigger.

# Challenges we ran into
Trying to learn Swift and Javascript, languages none of us were familiar with, was very difficult. Still, all of us put in significant time every day devoted to going through Swift tutorials to design an app. Integrating bluetooth turned out to be another major hurdle because the code was complex and difficult to understand for beginners of the language. It took us 2 or 3 days before we managed to get a working bluetooth connection that could send data between the phone and the Raspberry Pi, and in a week-long competition, that ended up costing us way too much valuable time.

Additionally, through halfway of the printing process of the gun, our 3D printer was either interrupted by someone or shut off, and we didn't have enough time to print another one before the hackathon ended. That ended up being the ultimate reason we couldn't finish the project. We tried to build a wood version after the hackathon but that never ended up being finished either.

Another challenge that we managed to work around was making the ray cast from one phone to another. Not sure how to approach it, our solution was to use the phone's camera as the scope for the gun. That way, when the trigger is pressed, the phone analyzes the color input in the scope area to determine whether you hit another player or not. This is explained in detail in the below section.

# Accomplishments that we're proud of
In the end, we managed to bring the phone app to its completion. We had a working single player component that kept score with every enemy alien you shot down. The multiplayer component could connect to the Raspberry Pi, transfer information and it could detect when you had hit another player and append to your score.

To detect whether you had hit another player, the multiplayer app would have a period before the game started where each player shoots every other player to log the color of the person's clothes. Then, every time the trigger is pressed, the app tests the color input to logged colors to determine if the color received was close enough to appropriate an enemy hit. Despite having some major flaws, such as if two players colors are very similar or similar to the background, the code worked perfectly and made the app super lightweight and playable without the gun.

# What we learned
Although we were bummed that we couldn't present the whole idea, we knew our project was pretty ambitious given our time and lack of knowledge and experience going into it. Looking back though, our progress was pretty crazy. In a week, we learned enough about two completely different languages from our background to open a datastream between two devices, used a Raspberry Pi, a device none of us had used, and designed and developed a fully functional app (with a splash screen!). At least to me, it seems very impressive in retrospect. But the reasons it was possible are teamwork, our time commitment from day to night, as well as open source projects and tutorials from GitHub.
