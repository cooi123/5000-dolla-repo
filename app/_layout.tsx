import { useEffect, forwardRef, Ref, View } from "react";
import { TamaguiProvider } from "tamagui";
import { useFonts } from "expo-font";
import {
  Tabs as ExpoTabs,
  TabList,
  TabTrigger,
  TabSlot,
  TabTriggerSlotProps,
} from "expo-router/ui";
import { Text, Tabs, Separator, SizableText } from "tamagui";
import * as SplashScreen from "expo-splash-screen";
import { StatusBar } from "expo-status-bar";
import { config } from "../tamagui.config"; // your configuration
import { useColorScheme } from "@/hooks/useColorScheme";
import "react-native-reanimated";

// Prevent the splash screen from auto-hiding before asset loading is complete.
SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const colorScheme = useColorScheme();

  const [loaded] = useFonts({
    SpaceMono: require("../assets/fonts/SpaceMono-Regular.ttf"),
  });

  useEffect(() => {
    if (loaded) {
      SplashScreen.hideAsync();
    }
  }, [loaded]);

  if (!loaded) {
    return null;
  }

  return (
    <TamaguiProvider config={config} defaultTheme={colorScheme}>
      <ExpoTabs>
        <TabSlot />
        <TabList>
          <TabTrigger name="home" href="/" />
          <TabTrigger name="article" href="/explore" />
        </TabList>
        <Tabs
          defaultValue="tab1"
          orientation="horizontal"
          flexDirection="column"
          width="100%"
          borderWidth="$0.25"
          overflow="hidden"
          borderColor="$borderColor"
        >
          <Tabs.List
            separator={<Separator vertical />}
            aria-label="Manage your account"
          >
            <Tabs.Tab
              focusStyle={{
                backgroundColor: "$color3",
              }}
              flex={1}
              value="tab1"
            >
              <TabTrigger name="home" href="/">
                <SizableText fontFamily="$body">Home</SizableText>
              </TabTrigger>
            </Tabs.Tab>
            <Tabs.Tab
              focusStyle={{
                backgroundColor: "$color3",
              }}
              flex={1}
              value="tab2"
            >
              <TabTrigger name="article" href="/explore">
                <SizableText fontFamily="$body">Connections</SizableText>
              </TabTrigger>
            </Tabs.Tab>
          </Tabs.List>
        </Tabs>
      </ExpoTabs>
      <StatusBar style="auto" />
    </TamaguiProvider>
  );
}

export type TabButtonProps = TabTriggerSlotProps & {
  icon?: Icon;
};

export const TabButton = forwardRef(
  ({ icon, children, isFocused, ...props }: TabButtonProps, ref: Ref<View>) => {
    return (
      <Tabs.Tab
        ref={ref}
        {...props}
        style={[
          {
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            flexDirection: "column",
            gap: 5,
            padding: 10,
          },
          isFocused ? { backgroundColor: "white" } : undefined,
        ]}
      >
        <Text
          style={[{ fontSize: 16 }, isFocused ? { color: "white" } : undefined]}
        >
          {children}
        </Text>
      </Tabs.Tab>
    );
  }
);
