import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import HomepageFeatures from "@site/src/components/HomepageFeatures";

import Footer from "@site/src/components/Footer";
import Banner from "@site/src/components/Banner";
import CodeExample from "@site/src/components/CodeExample";

function HomepageHeader() {
  return (
    <>
      <Banner />
      <HomepageFeatures />
      <CodeExample />
      <Footer />
    </>
  );
}

export default function Home(): JSX.Element {
  const { siteConfig } = useDocusaurusContext();

  return (
    <Layout
      title={`${siteConfig.title}`}
      description="GetX is an extra-light and powerful solution for Flutter"
    >
      <HomepageHeader />
      <main />
    </Layout>
  );
}
