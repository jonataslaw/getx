import clsx from "clsx";
import Heading from "@theme/Heading";
import styles from "./styles.module.css";

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<"svg">>;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: "PERFORMANCE",
    Svg: require("@site/static/img/rocket.svg").default,
    description: (
      <>
        GetX is focused on performance and minimum consumption of resources.
        GetX does not use Streams or ChangeNotifier.
      </>
    ),
  },
  {
    title: "PRODUCTIVITY",
    Svg: require("@site/static/img/productivity.svg").default,
    description: (
      <>
        GetX uses an easy and pleasant syntax. No matter what you want to do,
        there is always an easier way with GetX.
      </>
    ),
  },
  {
    title: "ORGANIZATION",
    Svg: require("@site/static/img/organization.svg").default,
    description: (
      <>
        GetX allows the total decoupling of the View, presentation logic,
        business logic, dependency injection, and navigation.
      </>
    ),
  },
];

function Feature({ title, Svg, description }: FeatureItem) {
  return (
    <div className={clsx("col col--4")}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div
          className="row text-center"
          style={{ textAlign: "center", padding: "45px 0" }}
        >
          <div className="col">
            <h1>Principles</h1>
          </div>
        </div>
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
