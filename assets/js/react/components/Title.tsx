import React from "react";
interface TitleInterface {
    title: string;
  }

  export function Title({ title }: TitleInterface) {
    return (
      <div className="mb-11">
        <h1 className="text-center font-display text-4xl tracking-tighter text-app-800 antialiased sm:text-left">
          {title}
        </h1>
      </div>
    );
  }
