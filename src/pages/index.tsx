import React, { useEffect, useState } from 'react';

const IndexPage: React.FC = () => {
  const [posts, setPosts] = useState([]);

  useEffect(() => {
    (async () => {
      const res = await fetch('https://jsonplaceholder.typicode.com/posts');
      const posts = await res.json();
      setPosts(posts);
    })();
  }, []);

  return (
    <>
      <div>
        <h1>posts</h1>
        {posts.map(post => (
          <div
            key={post.id}
            style={{
              border: 'solid 1px #ccc',
              borderRadius: '2px',
              margin: '8px 0',
              padding: '16px',
            }}
          >
            <p style={{ margin: '2px' }}>{post.title}</p>
            <p style={{ margin: '2px', fontSize: '0.8em', color: '#333' }}>{post.body}</p>
          </div>
        ))}
      </div>
    </>
  );
};

export default IndexPage;
