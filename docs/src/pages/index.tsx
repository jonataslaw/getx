import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';

import styles from './index.module.css';

function HomepageHeader() {
  const Logo = require('@site/static/img/text.svg').default;
  const Flutter = require('@site/static/img/flutter.svg').default;
  return (
      <>
          <div className={styles.bg} style={{background: 'url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiBzdHlsZT0ibWFyZ2luOiBhdXRvOyBkaXNwbGF5OiBibG9jazsgei1pbmRleDogMTsgcG9zaXRpb246IHJlbGF0aXZlOyBzaGFwZS1yZW5kZXJpbmc6IGF1dG87IiB3aWR0aD0iMTM4MiIgaGVpZ2h0PSIxMjE2IiBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWlkWU1pZCIgdmlld0JveD0iMCAwIDEzODIgMTIxNiI+CjxnIHRyYW5zZm9ybT0idHJhbnNsYXRlKDY5MSw2MDgpIHNjYWxlKC0xLDEpIHRyYW5zbGF0ZSgtNjkxLC02MDgpIj48bGluZWFyR3JhZGllbnQgaWQ9ImxnLTAuNDM1NzU5NDI3Mzc2Mjc5NyIgeDE9IjAiIHgyPSIxIiB5MT0iMCIgeTI9IjAiPgogIDxzdG9wIHN0b3AtY29sb3I9IiM5NTI1YmUiIG9mZnNldD0iMCI+PC9zdG9wPgogIDxzdG9wIHN0b3AtY29sb3I9IiNlMjUwN2QiIG9mZnNldD0iMSI+PC9zdG9wPgo8L2xpbmVhckdyYWRpZW50PjxwYXRoIGQ9IiIgZmlsbD0idXJsKCNsZy0wLjQzNTc1OTQyNzM3NjI3OTcpIiBvcGFjaXR5PSIwLjQiPgogIDxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9ImQiIGR1cj0iMTYuNjY2NjY2NjY2NjY2NjY0cyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIGtleVRpbWVzPSIwOzAuMzMzOzAuNjY3OzEiIGNhbGNNb2RlPSJzcGxpbmUiIGtleVNwbGluZXM9IjAuNSAwIDAuNSAxOzAuNSAwIDAuNSAxOzAuNSAwIDAuNSAxIiBiZWdpbj0iMHMiIHZhbHVlcz0iTTAgMEwgMCA1MzAuMjczNDM3OTI2MjI1NFEgMzQ1LjUgMTg2LjQ3MzkyNzMwMDk4NDQ2ICA2OTEgMTYwLjM0MTc3MjI0MTM1MTNUIDEzODIgLTE1NS4wNjcwNTM0ODM3MzY4TCAxMzgyIDAgWjtNMCAwTCAwIDUyMi40MDI1ODMyMjc2MDkyUSAzNDUuNSAxNTkuNzYxNjE2OTg3NDgyMDYgIDY5MSAxMTcuNzAwOTExNzMxOTMwOTRUIDEzODIgLTE4MS42MzIzODc4ODkzNjc3NUwgMTM4MiAwIFo7TTAgMEwgMCA0NjguNzI3MjY4MjIwMjgzNVEgMzQ1LjUgMjc2LjAyODEyMjg4NjAyNDMgIDY5MSAyNTguMjcyNDU4Mjg2OTUzNzRUIDEzODIgLTI2MC4xMjM0OTA3NTY2NjU2NkwgMTM4MiAwIFo7TTAgMEwgMCA1MzAuMjczNDM3OTI2MjI1NFEgMzQ1LjUgMTg2LjQ3MzkyNzMwMDk4NDQ2ICA2OTEgMTYwLjM0MTc3MjI0MTM1MTNUIDEzODIgLTE1NS4wNjcwNTM0ODM3MzY4TCAxMzgyIDAgWiI+PC9hbmltYXRlPgo8L3BhdGg+PHBhdGggZD0iIiBmaWxsPSJ1cmwoI2xnLTAuNDM1NzU5NDI3Mzc2Mjc5NykiIG9wYWNpdHk9IjAuNCI+CiAgPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZCIgZHVyPSIxNi42NjY2NjY2NjY2NjY2NjRzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIga2V5VGltZXM9IjA7MC4zMzM7MC42Njc7MSIgY2FsY01vZGU9InNwbGluZSIga2V5U3BsaW5lcz0iMC41IDAgMC41IDE7MC41IDAgMC41IDE7MC41IDAgMC41IDEiIGJlZ2luPSItNC4xNjY2NjY2NjY2NjY2NjZzIiB2YWx1ZXM9Ik0wIDBMIDAgNjEzLjI2MDQxNTU5OTIzNjJRIDM0NS41IDEzOS45MzIyMTI5MTE4NTI1NiAgNjkxIDEwNS40NTM1MTMyMDIzMjMzOVQgMTM4MiAtMTAyLjAyNDI5NzkyNjA1NTYyTCAxMzgyIDAgWjtNMCAwTCAwIDU1My45MzE4NTg5MTU5ODQ4USAzNDUuNSAyODguMzAzMzA2MTQ0MDkyMDYgIDY5MSAyNzAuNjEwMDkxOTM4MzM5NlQgMTM4MiAtMTAyLjE2MDE3MDgzNzU5MDYxTCAxMzgyIDAgWjtNMCAwTCAwIDQ5Ny4yMzY1Nzk1Mzg3OTk0USAzNDUuNSAyOTcuNDMxODY5OTE0NTU0MzQgIDY5MSAyNjUuMzUwNTMwMjAxOTMxN1QgMTM4MiAtMjgzLjEzMDk5MDA1MDgwMzVMIDEzODIgMCBaO00wIDBMIDAgNjEzLjI2MDQxNTU5OTIzNjJRIDM0NS41IDEzOS45MzIyMTI5MTE4NTI1NiAgNjkxIDEwNS40NTM1MTMyMDIzMjMzOVQgMTM4MiAtMTAyLjAyNDI5NzkyNjA1NTYyTCAxMzgyIDAgWiI+PC9hbmltYXRlPgo8L3BhdGg+PHBhdGggZD0iIiBmaWxsPSJ1cmwoI2xnLTAuNDM1NzU5NDI3Mzc2Mjc5NykiIG9wYWNpdHk9IjAuNCI+CiAgPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZCIgZHVyPSIxNi42NjY2NjY2NjY2NjY2NjRzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIga2V5VGltZXM9IjA7MC4zMzM7MC42Njc7MSIgY2FsY01vZGU9InNwbGluZSIga2V5U3BsaW5lcz0iMC41IDAgMC41IDE7MC41IDAgMC41IDE7MC41IDAgMC41IDEiIGJlZ2luPSItOC4zMzMzMzMzMzMzMzMzMzJzIiB2YWx1ZXM9Ik0wIDBMIDAgNjUzLjA1MDk5ODYwMTMwNTFRIDM0NS41IDIwNC42MjkyMTUzOTIyNTA1ICA2OTEgMTY3LjM0NDU0MTg1OTIyOTA4VCAxMzgyIC0xNTQuNDg1OTExNDA5Nzc4NUwgMTM4MiAwIFo7TTAgMEwgMCA1MDcuNjA3NDY5NDA5NzE2NlEgMzQ1LjUgMjcwLjA0NDA2MjEyNzYwNDI2ICA2OTEgMjQ0LjMzNTYwMTQ2MDg0Nzg0VCAxMzgyIC0xNDMuMjg0NDcxOTE3ODAxNzRMIDEzODIgMCBaO00wIDBMIDAgNDcyLjQ3NTE3OTEwNjY1NzdRIDM0NS41IDI3My4zMDg3MTcyNTQ4OTQ0ICA2OTEgMjI5LjkyMjU2NjQxMjg4NTU0VCAxMzgyIC0yMDIuMTIyNTY5NTQwOTA1MjZMIDEzODIgMCBaO00wIDBMIDAgNjUzLjA1MDk5ODYwMTMwNTFRIDM0NS41IDIwNC42MjkyMTUzOTIyNTA1ICA2OTEgMTY3LjM0NDU0MTg1OTIyOTA4VCAxMzgyIC0xNTQuNDg1OTExNDA5Nzc4NUwgMTM4MiAwIFoiPjwvYW5pbWF0ZT4KPC9wYXRoPjxwYXRoIGQ9IiIgZmlsbD0idXJsKCNsZy0wLjQzNTc1OTQyNzM3NjI3OTcpIiBvcGFjaXR5PSIwLjQiPgogIDxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9ImQiIGR1cj0iMTYuNjY2NjY2NjY2NjY2NjY0cyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIGtleVRpbWVzPSIwOzAuMzMzOzAuNjY3OzEiIGNhbGNNb2RlPSJzcGxpbmUiIGtleVNwbGluZXM9IjAuNSAwIDAuNSAxOzAuNSAwIDAuNSAxOzAuNSAwIDAuNSAxIiBiZWdpbj0iLTEyLjQ5OTk5OTk5OTk5OTk5OHMiIHZhbHVlcz0iTTAgMEwgMCA2MTQuMDMwMjg5NjI0NzUxOFEgMzQ1LjUgMjk2LjM3NjQ4MTczODEyMjgzICA2OTEgMjc4LjE2NDIwMzM2NDYxNTE2VCAxMzgyIC0xMTAuNTY1ODU2OTI2OTU5NzhMIDEzODIgMCBaO00wIDBMIDAgNDg2LjEwOTc2ODEwODY3OTUzUSAzNDUuNSAyNTAuMDc4MDU5NjE0NzYwNDYgIDY5MSAyMTYuODc2NTY2NjEyNzA2NDhUIDEzODIgLTIxMi4zMzkxNzk3NDY1MjA0MUwgMTM4MiAwIFo7TTAgMEwgMCA0ODQuODA2OTQ3Nzk5MTI0NjZRIDM0NS41IDIyNy4zODIwMTM0MDgzOTYwNiAgNjkxIDIwOS45MDE2MDk3MzQzMTY3VCAxMzgyIC0xNjEuNzMwNjgxMDE2MTQxOTRMIDEzODIgMCBaO00wIDBMIDAgNjE0LjAzMDI4OTYyNDc1MThRIDM0NS41IDI5Ni4zNzY0ODE3MzgxMjI4MyAgNjkxIDI3OC4xNjQyMDMzNjQ2MTUxNlQgMTM4MiAtMTEwLjU2NTg1NjkyNjk1OTc4TCAxMzgyIDAgWiI+PC9hbmltYXRlPgo8L3BhdGg+PC9nPgo8L3N2Zz4=) center/cover'}}>
            <div className="container">
                <div>
                    <div className={styles.heroLeft}>
                        <h2 className={styles.heroText}>
                            <Logo className={styles.heroText} role="image"/> is an extra-light and powerful solution for <Flutter width={35}/>lutter
                        </h2>
                        <div>
                            <span className="pill">State </span>
                            <span className="pill">Navigation </span>
                            <span className="pill">Dependencies </span>
                        </div>
                        <div>
                            <Link
                                style={{color: "white", marginTop: 35  }}
                                className="button button--primary button--lg"
                                to="/docs/intro">
                                Get Started
                            </Link>
                        </div>
                    </div>
                </div>
            </div>
          </div>

          <HomepageFeatures />
          
          <div className="container landing-code">
              <h2 className="mb-4">Flutter Made Easy</h2>
              <div>
                  <img className="img-code" src="./img/img.png" alt="image code"/>
              </div>
          </div>

          <div className="footer-container" style={{background: 'url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiBzdHlsZT0ibWFyZ2luOmF1dG87YmFja2dyb3VuZDpyZ2JhKE5hTiwgTmFOLCBOYU4sIDApO2Rpc3BsYXk6YmxvY2s7ei1pbmRleDoxO3Bvc2l0aW9uOnJlbGF0aXZlIiB3aWR0aD0iMTYwOSIgaGVpZ2h0PSI4MTMiIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaWRZTWlkIiB2aWV3Qm94PSIwIDAgMTYwOSA4MTMiPgogICAgPGcgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoODA0LjUsNDA2LjUpIHNjYWxlKDEsLTEpIHRyYW5zbGF0ZSgtODA0LjUsLTQwNi41KSI+PGxpbmVhckdyYWRpZW50IGlkPSJsZy0wLjc5OTc0MTY0NTE3Njk0OTkiIHgxPSIwIiB4Mj0iMSIgeTE9IjAiIHkyPSIwIj4KICAgICAgICA8c3RvcCBzdG9wLWNvbG9yPSIjOTIyM2MwIiBvZmZzZXQ9IjAiPjwvc3RvcD4KICAgICAgICA8c3RvcCBzdG9wLWNvbG9yPSIjYmYwZDY4IiBvZmZzZXQ9IjEiPjwvc3RvcD4KICAgIDwvbGluZWFyR3JhZGllbnQ+PHBhdGggZD0iIiBmaWxsPSJ1cmwoI2xnLTAuNzk5NzQxNjQ1MTc2OTQ5OSkiIG9wYWNpdHk9IjAuNCI+CiAgICAgICAgPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZCIgZHVyPSIxMHMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiBrZXlUaW1lcz0iMDswLjMzMzswLjY2NzsxIiBjYWxjTW9kZT0ic3BsaW5lIiBrZXlTcGxpbmVzPSIwLjUgMCAwLjUgMTswLjUgMCAwLjUgMTswLjUgMCAwLjUgMSIgYmVnaW49IjBzIiB2YWx1ZXM9Ik0wIDBMIDAgNDA1LjQ1NTUxNDMxMTgwNzc1USA0MDIuMjUgMTI4LjU3NDYxNDM4Njg3NjYgIDgwNC41IDEwMS45NDUyODkyMDcxOTcxVCAxNjA5IC0xNDEuMjExNzk5OTY3MTk4MzdMIDE2MDkgMCBaO00wIDBMIDAgNDc5LjI3NDAyMzE1MjY2ODdRIDQwMi4yNSAyNDYuODc5NjU3MjAzMzQwNDMgIDgwNC41IDIyMS4xMzEwODgwMzg4MTc3MlQgMTYwOSAtNjQuMTMzMDY3MTkxNjgzODRMIDE2MDkgMCBaO00wIDBMIDAgNDY2Ljg2MjY1OTIwNjk1NjhRIDQwMi4yNSAxODYuMDQ3ODE1Nzk4MzIwMTMgIDgwNC41IDE1MS43NzA5MTkzNzI4NzgxVCAxNjA5IC0xMjQuNzU2NjgyMjIwOTY5NjVMIDE2MDkgMCBaO00wIDBMIDAgNDA1LjQ1NTUxNDMxMTgwNzc1USA0MDIuMjUgMTI4LjU3NDYxNDM4Njg3NjYgIDgwNC41IDEwMS45NDUyODkyMDcxOTcxVCAxNjA5IC0xNDEuMjExNzk5OTY3MTk4MzdMIDE2MDkgMCBaIj48L2FuaW1hdGU+CiAgICA8L3BhdGg+PHBhdGggZD0iIiBmaWxsPSJ1cmwoI2xnLTAuNzk5NzQxNjQ1MTc2OTQ5OSkiIG9wYWNpdHk9IjAuNCI+CiAgICAgICAgPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZCIgZHVyPSIxMHMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiBrZXlUaW1lcz0iMDswLjMzMzswLjY2NzsxIiBjYWxjTW9kZT0ic3BsaW5lIiBrZXlTcGxpbmVzPSIwLjUgMCAwLjUgMTswLjUgMCAwLjUgMTswLjUgMCAwLjUgMSIgYmVnaW49Ii0xLjY2NjY2NjY2NjY2NjY2NjdzIiB2YWx1ZXM9Ik0wIDBMIDAgMzUzLjgwODY4NDc2NDI1NzZRIDQwMi4yNSAyNjUuNjk0NTQ1MTkxMjc0ODcgIDgwNC41IDIzMi4zMzQyNzUwNzE5NjkyVCAxNjA5IC0xNjQuNDYyODEwODgzMzYyOEwgMTYwOSAwIFo7TTAgMEwgMCAzOTMuMDkyMDcxMjQ5ODMwOVEgNDAyLjI1IDIyNi4yMzE3MjgwODQ0NzkzOSAgODA0LjUgMjAyLjAzMjQ4MjM4MDgwMjVUIDE2MDkgLTE4Ni40NjUxMzg2MTczMTA5TCAxNjA5IDAgWjtNMCAwTCAwIDUwMy4zNDI1MzM4MDUzMTZRIDQwMi4yNSAxNjUuNzMyNjc5Mzc1MjU4NjcgIDgwNC41IDE0Ny4xNzU0MDU4MDg0MDU2VCAxNjA5IC0xNi44MTI1NzMyMTQ1MjYzNjdMIDE2MDkgMCBaO00wIDBMIDAgMzUzLjgwODY4NDc2NDI1NzZRIDQwMi4yNSAyNjUuNjk0NTQ1MTkxMjc0ODcgIDgwNC41IDIzMi4zMzQyNzUwNzE5NjkyVCAxNjA5IC0xNjQuNDYyODEwODgzMzYyOEwgMTYwOSAwIFoiPjwvYW5pbWF0ZT4KICAgIDwvcGF0aD48cGF0aCBkPSIiIGZpbGw9InVybCgjbGctMC43OTk3NDE2NDUxNzY5NDk5KSIgb3BhY2l0eT0iMC40Ij4KICAgICAgICA8YW5pbWF0ZSBhdHRyaWJ1dGVOYW1lPSJkIiBkdXI9IjEwcyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIGtleVRpbWVzPSIwOzAuMzMzOzAuNjY3OzEiIGNhbGNNb2RlPSJzcGxpbmUiIGtleVNwbGluZXM9IjAuNSAwIDAuNSAxOzAuNSAwIDAuNSAxOzAuNSAwIDAuNSAxIiBiZWdpbj0iLTMuMzMzMzMzMzMzMzMzMzMzNXMiIHZhbHVlcz0iTTAgMEwgMCA0MDAuNDIyNTkzNTI0NjEzMTVRIDQwMi4yNSAxNDQuMzYwOTIzOTI5MTAwOTUgIDgwNC41IDExMS42NDA1OTAwNjE1Njc5OVQgMTYwOSAtMTUyLjE1OTQ5MTczOTUyOTEzTCAxNjA5IDAgWjtNMCAwTCAwIDM0MS4yNDcyNDYzNzgwNjM5USA0MDIuMjUgMTExLjc4NzY5MTc3ODIyNzM4ICA4MDQuNSA5MC4zMTg2MzQxOTI0MzAxOFQgMTYwOSAtMjguMzYzNjY1NjU1Mjg4OEwgMTYwOSAwIFo7TTAgMEwgMCAzMjkuNzg3Mjg5NjczNjYzOTZRIDQwMi4yNSA5OC4zNjI4ODIyNjUwMDEwMiAgODA0LjUgNzUuMTgyNzMwMjczODkwODVUIDE2MDkgLTQxLjk3MzkwNTQ0NzQyMjExTCAxNjA5IDAgWjtNMCAwTCAwIDQwMC40MjI1OTM1MjQ2MTMxNVEgNDAyLjI1IDE0NC4zNjA5MjM5MjkxMDA5NSAgODA0LjUgMTExLjY0MDU5MDA2MTU2Nzk5VCAxNjA5IC0xNTIuMTU5NDkxNzM5NTI5MTNMIDE2MDkgMCBaIj48L2FuaW1hdGU+CiAgICA8L3BhdGg+PHBhdGggZD0iIiBmaWxsPSJ1cmwoI2xnLTAuNzk5NzQxNjQ1MTc2OTQ5OSkiIG9wYWNpdHk9IjAuNCI+CiAgICAgICAgPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZCIgZHVyPSIxMHMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiBrZXlUaW1lcz0iMDswLjMzMzswLjY2NzsxIiBjYWxjTW9kZT0ic3BsaW5lIiBrZXlTcGxpbmVzPSIwLjUgMCAwLjUgMTswLjUgMCAwLjUgMTswLjUgMCAwLjUgMSIgYmVnaW49Ii01cyIgdmFsdWVzPSJNMCAwTCAwIDQ5OS41MTAyMTUyNjM5OTU2M1EgNDAyLjI1IDE5MS44MjQ1NTAzMTc0NzM2ICA4MDQuNSAxNjQuNTYyNDk2MTQxMjM1NlQgMTYwOSAtMTQzLjEwMjAxMDczODQ1NTQ4TCAxNjA5IDAgWjtNMCAwTCAwIDQ1Ny44MDA3ODkzMDU3NTMxNFEgNDAyLjI1IDI4MC4yNzYzMTkxMjM1MjQ0ICA4MDQuNSAyNDIuNDUyMjE0MjAyODMyNThUIDE2MDkgLTE2My4yMDA5MTY1MjUwNDgzNEwgMTYwOSAwIFo7TTAgMEwgMCA0NTAuNzk1Mjc1NjU0NTA1NFEgNDAyLjI1IDIzMy4yMDY4OTYwNTM2OTIyOCAgODA0LjUgMTg4Ljc3NTYyNDQxMjM1Mzc1VCAxNjA5IC0xMTcuNzc0NjYzMjI1MTQ3NDRMIDE2MDkgMCBaO00wIDBMIDAgNDk5LjUxMDIxNTI2Mzk5NTYzUSA0MDIuMjUgMTkxLjgyNDU1MDMxNzQ3MzYgIDgwNC41IDE2NC41NjI0OTYxNDEyMzU2VCAxNjA5IC0xNDMuMTAyMDEwNzM4NDU1NDhMIDE2MDkgMCBaIj48L2FuaW1hdGU+CiAgICA8L3BhdGg+PHBhdGggZD0iIiBmaWxsPSJ1cmwoI2xnLTAuNzk5NzQxNjQ1MTc2OTQ5OSkiIG9wYWNpdHk9IjAuNCI+CiAgICAgICAgPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZCIgZHVyPSIxMHMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiBrZXlUaW1lcz0iMDswLjMzMzswLjY2NzsxIiBjYWxjTW9kZT0ic3BsaW5lIiBrZXlTcGxpbmVzPSIwLjUgMCAwLjUgMTswLjUgMCAwLjUgMTswLjUgMCAwLjUgMSIgYmVnaW49Ii02LjY2NjY2NjY2NjY2NjY2N3MiIHZhbHVlcz0iTTAgMEwgMCAzNzAuNTg1MjY1NzQwNTIzNlEgNDAyLjI1IDEzNy45NTY1Njg5MTk4Nzg1MiAgODA0LjUgMTAxLjkzODA0MjcwMjAyNzAyVCAxNjA5IC0yMDUuMDg3MjAxMTI1MDQzNDZMIDE2MDkgMCBaO00wIDBMIDAgMzM4LjY3MDIwNTU2NzI2NzlRIDQwMi4yNSAxNDkuODAyNTI2NDI2MjcwMDggIDgwNC41IDEyMi4wODkxMDU1MDIzNzUyOFQgMTYwOSAtODMuOTc3MDY0ODEzNjEzNTRMIDE2MDkgMCBaO00wIDBMIDAgMzI3LjQzOTQ5NDUyMDA0ODNRIDQwMi4yNSAxODQuNjU1ODcwNzkyNzY4NTUgIDgwNC41IDE1MS41NTI0MjgyODc5OTY4VCAxNjA5IC0xNjUuNTE2MDM3MjY5MDE5NTNMIDE2MDkgMCBaO00wIDBMIDAgMzcwLjU4NTI2NTc0MDUyMzZRIDQwMi4yNSAxMzcuOTU2NTY4OTE5ODc4NTIgIDgwNC41IDEwMS45MzgwNDI3MDIwMjcwMlQgMTYwOSAtMjA1LjA4NzIwMTEyNTA0MzQ2TCAxNjA5IDAgWiI+PC9hbmltYXRlPgogICAgPC9wYXRoPjxwYXRoIGQ9IiIgZmlsbD0idXJsKCNsZy0wLjc5OTc0MTY0NTE3Njk0OTkpIiBvcGFjaXR5PSIwLjQiPgogICAgICAgIDxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9ImQiIGR1cj0iMTBzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIga2V5VGltZXM9IjA7MC4zMzM7MC42Njc7MSIgY2FsY01vZGU9InNwbGluZSIga2V5U3BsaW5lcz0iMC41IDAgMC41IDE7MC41IDAgMC41IDE7MC41IDAgMC41IDEiIGJlZ2luPSItOC4zMzMzMzMzMzMzMzMzMzRzIiB2YWx1ZXM9Ik0wIDBMIDAgNDM1LjgyMzk3MDA0ODkzOTZRIDQwMi4yNSAyMDAuOTQyMTExMTIzMzQ2MDggIDgwNC41IDE2Mi4yNjAwNzQwNzQzODE1OFQgMTYwOSAtNTIuMDAwMzEzNDI2NDQ1N0wgMTYwOSAwIFo7TTAgMEwgMCA0MzEuNTY3ODczMTM1Mzc3NDVRIDQwMi4yNSAxMDIuMjY4OTQxODQwNTI0NjYgIDgwNC41IDczLjE1Mzc1MTg0NTQ0OTA1VCAxNjA5IC0xNTcuODI5MTM1NTYwMDYzNDNMIDE2MDkgMCBaO00wIDBMIDAgNDc0LjI0OTQ0OTc1NzYwMzNRIDQwMi4yNSAxMTYuNjYwNjQ1NDAxMTAyNzggIDgwNC41IDkwLjU1MjkzNjkyMDU2MDcxVCAxNjA5IC0xNjcuNDI3MjUwMjIxOTY1NUwgMTYwOSAwIFo7TTAgMEwgMCA0MzUuODIzOTcwMDQ4OTM5NlEgNDAyLjI1IDIwMC45NDIxMTExMjMzNDYwOCAgODA0LjUgMTYyLjI2MDA3NDA3NDM4MTU4VCAxNjA5IC01Mi4wMDAzMTM0MjY0NDU3TCAxNjA5IDAgWiI+PC9hbmltYXRlPgogICAgPC9wYXRoPjwvZz4KPC9zdmc+) center/cover'}}>
              <div style={{display: 'flex', justifyContent: 'space-between', flexDirection: "column", height: '100%'}}>
                  <div className="container" style={{height: '100%'}}>
                      <div className="row">
                          <div className="col col--4">
                              <Link to="/" style={{display: 'inline-block'}}><Logo className={styles.heroText} role="image"/></Link>
                          </div>
                          <div className="col col--4">
                              <div><h2>Documentation</h2></div>
                              <div><Link to="/docs/intro">Get Started</Link></div>
                              <div><Link to="/docs/intro">Demo</Link></div>
                              <div><Link to="/docs/intro">Concepts</Link></div>
                              <div><Link to="/docs/intro">Features</Link></div>
                              <div><Link to="/docs/intro">Advanced</Link></div>
                          </div>
                          <div className="col col--4">
                              <h2>Commnuity</h2>
                              <div>
                                  <Link to="https://communityinviter.com/apps/getxworkspace/getx">
                                      <img className="media-link" src="./img/slack.png" alt="slack"/>
                                  </Link>

                                  <Link to="https://discord.com/invite/9Hpt99N">
                                      <img className="media-link" src="./img/discord.svg" alt="discord"/>
                                  </Link>

                                  <Link to="https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g">
                                      <img className="media-link" src="./img/telegram.svg" alt="telegram"/>
                                  </Link>

                                  <Link to="https://github.com/jonataslaw/getx">
                                      <img className="media-link" src="./img/github.svg" alt="github"/>
                                  </Link>
                              </div>
                          </div>
                      </div>
                  </div>
                  <div className={styles.copyright}>
                      GetX mantained by <Link to="https://github.com/jonataslaw">jonataslaw</Link>, MIT Licence.
                  </div>
              </div>
          </div>
      </>
  );
}

export default function Home(): JSX.Element {
  const {siteConfig} = useDocusaurusContext();

  return (
    <Layout
      title={`${siteConfig.title}`}
      description="GetX is an extra-light and powerful solution for Flutter">
      <HomepageHeader />
      <main/>
    </Layout>
  );
}
