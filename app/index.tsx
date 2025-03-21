import { Image, StyleSheet, Platform } from "react-native";
import { Text, H1, H2, H3, Paragraph } from "tamagui";

import { HelloWave } from "@/components/HelloWave";
import ParallaxScrollView from "@/components/ParallaxScrollView";
import { ThemedView } from "@/components/ThemedView";
import { Button, Input } from "tamagui";

export default function HomeScreen() {
  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: "#A1CEDC", dark: "#1D3D47" }}
      headerImage={
        <Image
          source={require("@/assets/images/partial-react-logo.png")}
          style={styles.reactLogo}
        />
      }
    >
      <ThemedView style={styles.titleContainer}>
        <H1>Welcome!</H1>
        <HelloWave />
      </ThemedView>
      <ThemedView style={styles.stepContainer}>
        <H2>Step 1: Try it</H2>
        <Paragraph>
          Edit <Text>app/(tabs)/index.tsx</Text> to see changes. Press{" "}
          <Text>
            {Platform.select({
              ios: "cmd + d",
              android: "cmd + m",
              web: "F12",
            })}
          </Text>{" "}
          to open developer tools.
        </Paragraph>
      </ThemedView>
      <ThemedView style={styles.stepContainer}>
        <H2>Step 2: Explore</H2>
        <Paragraph>
          Tap the Explore tab to learn more about what's included in this
          starter app.
        </Paragraph>
      </ThemedView>
      <ThemedView style={styles.stepContainer}>
        <H2>Step 3: Get a fresh start</H2>
        <Paragraph>
          When you're ready, run <Text>npm run reset-project</Text> to get a
          fresh <Text>app</Text> directory. This will move the current{" "}
          <Text>app</Text> to <Text>app-example</Text>.
        </Paragraph>
        <Button>Hello</Button>
        <Input placeholder="HElloooo"></Input>
      </ThemedView>
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  titleContainer: {
    flexDirection: "row",
    alignItems: "center",
    gap: 8,
  },
  stepContainer: {
    gap: 8,
    marginBottom: 8,
  },
  reactLogo: {
    height: 178,
    width: 290,
    bottom: 0,
    left: 0,
    position: "absolute",
  },
});
